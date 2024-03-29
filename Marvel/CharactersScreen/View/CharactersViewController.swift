//
//  ViewController.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 25.04.2023.
//

import Firebase
import Realm
import SnapKit
import UIKit

protocol ViewControllerInput: AnyObject {
    func startIndicator()
    func stopIndicator()
    func showAlert(characters: @escaping () -> Void)
    func updateTable()
    func isSearchBarEmpty() -> Bool
    func passData(data: [CharactersClientModel])
}

final class CharactersViewController: UIViewController, UISearchBarDelegate {
    private var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    private lazy var searchBar: UISearchBar = searchController.searchBar
    private let presenter: PresenterInput

    private var characters: [CharactersClientModel] = []

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
        setupViews()
        setupConstraints()
        presenter.fetchFromServer()
        passData(data: characters)
    }

    func setupViews() {
        tableView = UITableView(frame: .zero)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        tableView.tableHeaderView = searchBar

        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.rowHeight = 80
        tableView.tableFooterView = activityIndicator
        searchBar.delegate = self

        navigationController?.isNavigationBarHidden = true
    }

    @objc private func didPullToRefresh() {
        print("start refresh")
        DispatchQueue.main.async {
            self.presenter.fetchData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    func setupConstraints() {
        tableView.snp.makeConstraints { make in make.edges.equalToSuperview() }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange _: String) {
        presenter.loadMoreData(name: searchBar.text!)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = true
        searchBar.endEditing(true)
        presenter.clearResults()
    }

    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        return activityIndicator
    }()
}

extension CharactersViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        searchController.isActive = false
        let result: CharactersClientModel = characters[indexPath.row]
        let detailsVC = HeroDetailsViewController(model: result, presenter: DetailsPresenter())
        navigationController?.pushViewController(detailsVC, animated: true)
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == characters.count - 1 {
            presenter.fetchDataOnSearch()
        }
    }
}

extension CharactersViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.setupModel(model: characters[indexPath.row])
        return cell
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

    func updateTable() {
        tableView.reloadData()
    }

    func showAlert(characters: @escaping () -> Void) {
        let alert = UIAlertController(title: "Alert", message: "Something went wrong", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "Try again", style: .default) { _ in characters() }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

    func passData(data: [CharactersClientModel]) {
        characters = data
    }
}
