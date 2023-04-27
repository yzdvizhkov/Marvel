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

    var items: [String] = ["Black Widow", "Black Panther", "Spider Man", "The Flash", "Iron Man", "Loki", "Shazam", "Captain America", "The Wasp", "Ant-Man"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

         tableView = UITableView(frame: .zero)
         tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
         tableView.delegate = self
         tableView.dataSource = self
         view.addSubview(tableView)
         tableView.snp.makeConstraints { (make) in make.edges.equalToSuperview()}
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = items[indexPath.row]
            return cell
        }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return items.count
        }
}

