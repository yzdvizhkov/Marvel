//
//  DetailsViewCell.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 18.07.2023.
//

import UIKit

final class DetailsTableViewCell: UITableViewCell {
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
        contentView.addSubview(nameLabel)
        nameLabel.numberOfLines = 2
        setupConstraints()
    }

    lazy var nameHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    func setupConstraints() {
        nameHeader.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(15)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameHeader)
            make.trailing.equalToSuperview()
            make.top.equalTo(nameHeader.snp.bottom)
            make.height.equalTo(15)
        }
    }

    func setupDetailsModel(with title: String, value: String) {
        nameHeader.text = title
        nameLabel.text = value
    }
}
