//
//  ReusableView.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 07.05.2023.
//

import UIKit

extension ReusableView {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
