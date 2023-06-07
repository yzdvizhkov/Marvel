//
//  ViewController.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 25.04.2023.
//

import SnapKit
import UIKit

protocol ViewControllerInput: AnyObject {
    func startIndicator()
    func stopIndicator()
    func showAlert(characters: @escaping () -> Void)
    func updateTable()
    func isSearchBarEmpty() -> Bool
}

class CharactersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    private var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    private lazy var searchBar: UISearchBar = searchController.searchBar
    private var presenter: PresenterInput

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
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        tableView.tableHeaderView = searchBar

        tableView.snp.makeConstraints { make in make.edges.equalToSuperview() }
        tableView.rowHeight = 80
        tableView.tableFooterView = activityIndicator
        searchBar.delegate = self

        presenter.fetchInitialData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.setupModel(result: presenter.getCharactersResults()[indexPath.row])
        return cell
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        presenter.getCharactersResults().count
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        searchController.isActive = false
        let result: CharactersResult = presenter.getCharactersResults()[indexPath.row]
        let rootVC = HeroDetailsViewController(result: result)
        let navVC = UINavigationController(rootViewController: rootVC)
        present(navVC, animated: false)
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == presenter.getCharactersResults().count - 1 {
            presenter.fetchDataOnSearch()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange _: String) {
        presenter.loadMoreData(name: searchBar.text!)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.clearResults()
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

    func updateTable() {
        tableView.reloadData()
    }
}

extension CharactersViewController: ViewControllerInput {
    func isSearchBarEmpty() -> Bool {
        searchBar.text == ""
    }

    func startIndicator() {
        activityIndicator.startAnimating()
    }

    func stopIndicator() {
        activityIndicator.stopAnimating()
    }

    func showAlert(characters: @escaping () -> Void) {
        let alert = UIAlertController(title: "Alert", message: "Something went wrong", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "Try again", style: .default) { _ in characters() }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
