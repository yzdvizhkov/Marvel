//
//  MyCollectionViewCell.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 26.07.2023.
//

import SDWebImage
import UIKit

class MyCollectionViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(nameHeader)
        contentView.addSubview(comicsImageView)
        setupConstraints()
    }

    lazy var nameHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    lazy var comicsImageView: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        return img
    }()

    func setupConstraints() {
        nameHeader.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(15)
        }
        comicsImageView.snp.makeConstraints { make in
            make.leading.equalTo(nameHeader)
            make.trailing.equalToSuperview()
            make.top.equalTo(nameHeader.snp.bottom)
        }
    }

    func setupComicsModel(value: String) {
        nameHeader.text = "Comics"
        comicsImageView.image = UIImage(named: value)
        comicsImageView.sd_setImage(with: URL(string: value))
    }
}
