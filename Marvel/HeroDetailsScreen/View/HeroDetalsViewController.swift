//
//  SuperHeroDetalsController.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 07.05.2023.
//

import UIKit

protocol DetailsViewControllerInput: AnyObject {
    func passData(data: [String])
}

class HeroDetailsViewController: UIViewController, UITableViewDelegate {
    var model: CharactersClientModel?
    private var detailsTableView: UITableView!
    var rows: [DetailRowType] = []
    private var comicsUrls: [String] = []
    private let presenter: DetailsPresenterInput
    var testImages = ["apple", "banana"]

    init(model: CharactersClientModel?, presenter: DetailsPresenter) {
        self.model = model
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var characterImageView: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        return img
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(characterImageView)
        setupViews()
        configure(with: model!)
        setupConstraints()
        navigationItem.title = model?.name
        navigationItem.titleView?.backgroundColor = .black
        navigationController?.isNavigationBarHidden = false
        rows.append(.name(title: "Name", name: model!.name))
        rows.append(.descripction(title: "Description", description: model?.description ?? ""))
        presenter.fetchComics(characterId: model!.characterId)
        passData(data: comicsUrls)
        detailsTableView.reloadData()
    }

    func setupConstraints() {
        characterImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }

        detailsTableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(characterImageView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }

    func setupViews() {
        detailsTableView = UITableView(frame: .zero)
        detailsTableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: "detailsCell")
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.rowHeight = 80
        view.addSubview(detailsTableView)
    }

    func configure(with _: CharactersClientModel) {
        characterImageView.sd_setImage(with: model!.imageUrl)
    }
}

extension HeroDetailsViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        rows.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row] {
        case let .name(title: title, name: name):
            let cell = detailsTableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as! DetailsTableViewCell
            cell.setupDetailsModel(with: title, value: name)
            return cell
        case let .descripction(title: title, description: description):
            let cell = detailsTableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as! DetailsTableViewCell
            cell.setupDetailsModel(with: title, value: description)
            return cell
        case let .comics(name: name, url: url):
            print("not ready yet")
            return UITableViewCell()
        }
    }
}

extension HeroDetailsViewController: DetailsViewControllerInput, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        testImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! MyCollectionViewCell
        cell.setupComicsModel(value: testImages[indexPath.row])
        return cell
    }

    func passData(data: [String]) {
        comicsUrls = data
    }
}
