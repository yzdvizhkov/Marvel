//
//  StorageService.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 29.06.2023.
//

import Foundation
import RealmSwift

protocol StorageServiceProtocol {
    func getCharacters() -> [CharactersClientModel]
//    func save(characters: [CharactersResult])
}

class StorageService: StorageServiceProtocol {
    lazy var realm: Realm = try! Realm()

    func getCharacters() -> [CharactersClientModel] {
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        let characters = realm.objects(StorageModel.self)
        return characters.map { result in
            CharactersClientModel(characterId: result.characterId, name: result.name, description: result.desc, imageUrl: URL(string: "result.imageUrl")!, isImageHidden: true)
        }
    }

//    func save(characters: [CharactersResult]) {
//        for character in characters {
//            let storageModel = StorageModel()
//            storageModel.name = character.name ?? ""
//            storageModel.desc = character.description ?? ""
//            let path = character.thumbnail?.path ?? ""
//            let ext = character.thumbnail?.ext ?? ""
//            storageModel.imageUrl = "\(path).\(ext)"
//            try! realm.write { realm.add(storageModel) }
//        }
//    }
}
