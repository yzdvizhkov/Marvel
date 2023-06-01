//
//  CharactersPresenter.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 30.05.2023.
//

import UIKit

class CharactersPresenter {
    weak var charactersVewController: CharactersViewController?
    let marvelApiManager = MarvelApiManager()
    var charactersResults: [CharactersResult] = []

    func getCharacters(offset: Int = 0) {
        charactersVewController!.startActivivtyIndicator()
        marvelApiManager.getCharacters(offset: offset, completionHandler: { [weak self] result in
            guard let self = self else { return }
            self.charactersVewController!.stopActivivtyIndicator()
            switch result {
            case let .success(characters):
                let total = characters.charactersData.total
                let offset = characters.charactersData.offset
                self.charactersResults += characters.charactersData.charactersResults
                if total == offset { // stop activity indicator when all results are loaded
                    return
                }
                self.charactersVewController!.updateTable()
            case let .failure(error):
                self.charactersVewController!.showAlert {
                    self.getCharacters(offset: offset)
                }
                debugPrint(error)
            }
        })
    }
}
