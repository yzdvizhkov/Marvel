//
//  CustomTableViewCell.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 28.04.2023.
//

import Foundation
import UIKit

class CustomTableViewCell: UITableViewCell {
    
    var superHero:SuperHero? {
        didSet {
            guard let superHeroItem = superHero else {return}
            if let name = superHeroItem.name {
                superHeroImageView.image = UIImage(named: name)
                nameLabel.text = " \(name) "
            }
            if let description = superHeroItem.description {
                descriptionLabel.text = " \(description) "
            }
        }
    }
    
    let superHeroImageView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.backgroundColor = .yellow
        img.clipsToBounds = true
        return img
        }()
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true

        return label
    }()
    
    let descriptionLabel:UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        return label
    }()
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false // tell iOS not to create Auto Layout constraints automatically
        view.clipsToBounds = true // this will make sure its children do not go out of the boundary
        return view
       }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        containerView.addSubview(superHeroImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        self.contentView.addSubview(containerView)

        containerView.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)

        containerView.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant: -10).isActive = true
        containerView.heightAnchor.constraint(equalToConstant:72).isActive = true

        superHeroImageView.heightAnchor.constraint(equalToConstant:42).isActive = true
        superHeroImageView.widthAnchor.constraint(equalToConstant:42).isActive = true
        superHeroImageView.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor, constant: 16).isActive = true
        superHeroImageView.topAnchor.constraint(equalTo:self.containerView.topAnchor, constant:15).isActive = true
        superHeroImageView.bottomAnchor.constraint(equalTo:self.containerView.bottomAnchor, constant:-15).isActive = true

        nameLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor, constant:15).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo:self.superHeroImageView.trailingAnchor, constant:15).isActive = true

        descriptionLabel.bottomAnchor.constraint(equalTo:self.containerView.bottomAnchor, constant:-15).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo:self.nameLabel.leadingAnchor).isActive = true
    
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
