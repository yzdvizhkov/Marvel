//
//  SuperHeroDetalsController.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 07.05.2023.
//

import UIKit

class HeroDetailsViewController: UIViewController {
    var superHero: SuperHero?

    init(superHero: SuperHero?) {
        self.superHero = superHero
        super.init(nibName: nil, bundle: nil)
    }

    lazy var myLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = superHero?.name
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(myLabel)

        // Set its constraint to display it on screen
        myLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        myLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true

        myLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        myLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
