//
//  CustomTableViewCell.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 28.04.2023.
//

import Alamofire
import SDWebImage
import SnapKit
import UIKit

final class CustomTableViewCell: UITableViewCell {
    let marvelApiManager = MarvelApiManager()
    let rc = RefreshControlService()

    func setupModel(result: CharactersResult?) {
        guard let charactersResult = result else { return }
//        print(rc.testFeatureFlag)
        if let name = charactersResult.name {
            nameLabel.text = " \(name) "
            superHeroImageView.image = UIImage(named: name)
        }
        if let description = charactersResult.description {
            descriptionLabel.text = " \(description) "
        }
        guard let url = imageUrlString(result: charactersResult) else { return }
        superHeroImageView.sd_setImage(with: URL(string: url))
    }

    func imageUrlString(result: CharactersResult) -> String? {
        guard
            let path = result.thumbnail?.path,
            let ext = result.thumbnail?.ext
        else { return nil }
        return "\(path).\(ext)"
    }

    var superHeroImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.backgroundColor = .yellow
        img.clipsToBounds = true
        return img
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false // tell iOS not to create Auto Layout constraints automatically
        view.clipsToBounds = true // this will make sure its children do not go out of the boundary
        view.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        containerView.addSubview(superHeroImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        contentView.addSubview(containerView)

        containerView.snp.makeConstraints { make in
            make.height.equalTo(72)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
        }

        superHeroImageView.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.width.equalTo(superHeroImageView.snp.height)
            make.leading.equalTo(containerView.snp.leading).offset(16)
            make.top.equalTo(containerView.snp.top).offset(15)
            make.bottom.equalTo(containerView.snp.bottom).offset(-15)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(15)
            make.leading.equalTo(superHeroImageView.snp.trailing).offset(15)
            make.trailing.equalTo(containerView.snp.trailing)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(containerView.snp.bottom).offset(-15)
            make.leading.equalTo(nameLabel.snp.leading)
            make.trailing.equalTo(containerView.snp.trailing)
        }
    }

    func containerViewConstraints() -> UIView {
        containerView.snp.makeConstraints { make in
            make.height.equalTo(72)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
        }
        return containerView
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
