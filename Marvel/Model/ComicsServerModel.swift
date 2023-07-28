//
//  ComicsModel.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 26.07.2023.
//

import Foundation

struct ComicsServerModel: Decodable {
    let comicsData: ComicsData
    enum CodingKeys: String, CodingKey {
        case comicsData = "data"
    }
}

struct ComicsData: Decodable {
    var comicsResults: [ComicsResult]
    enum CodingKeys: String, CodingKey {
        case comicsResults = "results"
    }
}

struct ComicsResult: Decodable {
    let comicsThunbnail: ComicsThumbnail?
    enum CodingKeys: String, CodingKey {
        case comicsThunbnail = "thumbnail"
    }
}

struct ComicsThumbnail: Decodable {
    let path: String
    let ext: String
    enum CodingKeys: String, CodingKey {
        case path
        case ext = "extension"
    }
}
