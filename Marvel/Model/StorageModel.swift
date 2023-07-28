//
//  DBCharacter.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 29.06.2023.
//

import Foundation
import RealmSwift

class StorageModel: Object {
    static var entityName: String {
        "Character"
    }

    @Persisted var name: String = ""
    @Persisted var desc: String = ""
    @Persisted var characterId: Double = 0
    @Persisted var imageUrl: String = ""
}

extension StorageModel {
    typealias Model = CharactersResult

    func update(from model: Model) {
        characterId = model.characterId
        name = model.name ?? ""
        desc = model.description ?? ""
        let path = model.thumbnail?.path ?? ""
        let ext = model.thumbnail?.ext ?? ""
        imageUrl = "\(path).\(ext)"
    }
}
