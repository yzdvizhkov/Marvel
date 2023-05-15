//
//  CharactersData.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 10.05.2023.
//

import Foundation

struct Characters: Decodable {
    let charactersData: CharactersData
    enum CodingKeys: String, CodingKey {
        case charactersData = "data"
    }
}

struct CharactersData: Decodable {
    var charactersResults: [CharactersResult]
    enum CodingKeys: String, CodingKey {
        case charactersResults = "results"
    }
}

struct CharactersResult: Decodable {
    let name: String?
    let description: String?
    let thumbnail: Thumbnail?
}

struct Thumbnail: Decodable {
    let path: String
    let ext: String
    enum CodingKeys: String, CodingKey {
        case path
        case ext = "extension"
    }
}
