//
//  ViewController.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 25.04.2023.
//

import SnapKit
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var tableView: UITableView!

    private var charactersResults: [CharactersResult] = []

    var marvelApiManager = MarvelApiManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: .zero)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in make.edges.equalToSuperview() }
        tableView.rowHeight = 80

        getCharacters()
    }

    func getCharacters() {
        marvelApiManager.getCharacters { [weak self] result in
            switch result {
            case let .success(characters):
                self?.charactersResults = characters.charactersData.charactersResults
                self?.tableView.reloadData()
            case let .failure(error):
                debugPrint(error)
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.setupModel(result: charactersResults[indexPath.row])
        return cell
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        charactersResults.count
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let result = charactersResults[indexPath.row]
        let rootVC = HeroDetailsViewController(result: result)
        let navVC = UINavigationController(rootViewController: rootVC)
        present(navVC, animated: true)
    }
}
