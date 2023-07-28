//
//  CharactersData.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 10.05.2023.
//

import Foundation

struct CharactersServerModel: Decodable {
    let charactersData: CharactersData
    enum CodingKeys: String, CodingKey {
        case charactersData = "data"
    }
}

struct CharactersData: Decodable {
    var charactersResults: [CharactersResult]
    var limit: Int
    var total: Int
    var offset: Int
    enum CodingKeys: String, CodingKey {
        case limit
        case total
        case offset
        case charactersResults = "results"
    }
}

struct CharactersResult: Decodable {
    let name: String?
    let description: String?
    let thumbnail: Thumbnail?
    let characterId: Double
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case thumbnail
        case characterId = "id"
    }
}

struct Thumbnail: Decodable {
    let path: String
    let ext: String
    enum CodingKeys: String, CodingKey {
        case path
        case ext = "extension"
    }
}
