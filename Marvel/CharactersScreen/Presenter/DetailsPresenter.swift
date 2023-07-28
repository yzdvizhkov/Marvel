//
//  DetailsPresenter.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 25.07.2023.
//

import Foundation

protocol DetailsPresenterInput {
    func fetchComics(characterId: Double)
}

class DetailsPresenter: DetailsPresenterInput {
    var comicsUrls: [String] = []
    let marvelApiManager: MarvelApiManager = .init()
    weak var detailsViewController: DetailsViewControllerInput?

    func fetchComics(characterId: Double) {
        marvelApiManager.getComicsByCharacterId(characterId: characterId, completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(comics):
                self.comicsUrls = comics.comicsData.comicsResults.map { comicsResult in
                    "\(comicsResult.comicsThunbnail?.path ?? "").\(comicsResult.comicsThunbnail?.ext ?? "")"
                }
                self.detailsViewController?.passData(data: self.comicsUrls)
            case let .failure(error):
                debugPrint(error)
            }
        })
    }
}
