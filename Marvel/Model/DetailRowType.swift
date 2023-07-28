//
//  DetailRowType.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 24.07.2023.
//

import Foundation

enum DetailRowType {
    case name(title: String, name: String)
    case descripction(title: String, description: String)
    case comics(name: String, url: String)
}
