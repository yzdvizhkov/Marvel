//
//  ViewController.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 25.04.2023.
//

import SnapKit
import UIKit

class CharactersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    private var tableView: UITableView!
//    private var charactersResults: [CharactersResult] = []
    private var filteredData: [CharactersResult]!
    let searchController = UISearchController(searchResultsController: nil)
    private lazy var searchBar: UISearchBar = searchController.searchBar
    var isSearching = false
    private var presenter: CharactersPresenter
    var total = 0
    var searchText: String = ""
    var searchTimer: Timer?
    var marvelApiManager = MarvelApiManager()

    init(presenter: CharactersPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: .zero)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        filteredData = presenter.charactersResults
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        tableView.tableHeaderView = searchBar

        tableView.snp.makeConstraints { make in make.edges.equalToSuperview() }
        tableView.rowHeight = 80
        tableView.tableFooterView = activityIndicator
        searchBar.delegate = self

        presenter.getCharacters()
    }

    @objc func fetchCheractersByName(offset: Int = 0, name: String) {
        activityIndicator.startAnimating()
        marvelApiManager.getCharacters(offset: offset, name: name, completionHandler: { [weak self] result in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            switch result {
            case let .success(characters):
                let total = characters.charactersData.total
                let offset = characters.charactersData.offset
                self.filteredData += characters.charactersData.charactersResults
                if total == offset { // stop activity indicator when all results are loaded
                    return
                }
                self.tableView.reloadData()
            case let .failure(error):
                let alert = UIAlertController(title: "Hey", message: "This is an Alert", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Working!!", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                debugPrint(error)
            }
        })
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        isSearching == true ? cell.setupModel(result: filteredData[indexPath.row]) : cell.setupModel(result: presenter.charactersResults[indexPath.row])
        return cell
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        isSearching ? filteredData.count : presenter.charactersResults.count
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        searchController.isActive = false
        let result: CharactersResult = isSearching == true ? filteredData[indexPath.row] : presenter.charactersResults[indexPath.row]
        let rootVC = HeroDetailsViewController(result: result)
        let navVC = UINavigationController(rootViewController: rootVC)
        present(navVC, animated: true)
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !isSearching && indexPath.row == presenter.charactersResults.count - 1 {
            presenter.getCharacters(offset: presenter.charactersResults.count)
        } else if isSearching && indexPath.row == filteredData.count - 1 {
            fetchCheractersByName(offset: filteredData.count, name: searchText)
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        if searchBar.text == "" {
            isSearching = false
        } else {
            isSearching = true
            filteredData = []

            // Invalidate and reinitiate
            searchTimer?.invalidate()

            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
                DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.fetchCheractersByName(offset: self.filteredData.count, name: searchText)
                    }
                }
            })
        }
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = nil
        searchBar.showsCancelButton = true
        searchBar.endEditing(true)
        tableView.reloadData()
    }

    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        return activityIndicator
    }()

    func startActivivtyIndicator() {
        activityIndicator.startAnimating()
    }

    func stopActivivtyIndicator() {
        activityIndicator.stopAnimating()
    }

    func updateTable() {
        tableView.reloadData()
    }

    func showAlert(characters: @escaping () -> Void) {
        let alert = UIAlertController(title: "Alert", message: "Something went wrong", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "Try again", style: .default) { _ in
            characters()
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}