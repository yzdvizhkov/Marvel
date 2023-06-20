//
//  CharactersPresenter.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 30.05.2023.
//

import Foundation

protocol PresenterInput {
    func fetchInitialData()
    func fetchData(offset: Int)
    func fetchData(offset: Int, name: String)
    func fetchDataOnSearch()
    func loadMoreData(name: String)
    func clearResults()
//    func fetchRCValues()
}

class CharactersPresenter: PresenterInput {
    func clearResults() {
        isSearching = false
    }

    func fetchInitialData() {
        getCharacters()
    }

    func fetchData(offset: Int) {
        getCharacters(offset: offset)
    }

    func fetchData(offset: Int, name: String) {
        getCharacters(offset: offset, name: name)
    }

    weak var charactersVewController: ViewControllerInput?
    let marvelApiManager = MarvelApiManager()
    var charactersResults: [CharactersResult] = []
    var filteredData: [CharactersResult] = []
    var searchText: String = ""
    var searchTimer: Timer?
    var isSearching = false
//    var rc = RemoteConfigService()

    func getCharacters(offset: Int = 0) {
        charactersVewController?.startIndicator()
        marvelApiManager.getCharacters(offset: offset, completionHandler: { [weak self] result in
            guard let self = self else { return }
            self.charactersVewController?.stopIndicator()
            switch result {
            case let .success(characters):
                let total = characters.charactersData.total
                let offset = characters.charactersData.offset
                self.charactersResults += characters.charactersData.charactersResults
                if total == offset {
                    return
                }
                let clientModel = self.setupClientModel(charactersResults: self.charactersResults)
                self.charactersVewController?.passData(data: clientModel)
            case let .failure(error):
                self.charactersVewController!.showAlert { self.getCharacters(offset: offset) }
                debugPrint(error)
            }
        })
    }

    func setupClientModel(charactersResults: [CharactersResult]) -> [CharactersClientModel] {
        charactersResults.map { result in
            let path = result.thumbnail?.path ?? ""
            let ext = result.thumbnail?.ext ?? ""
            let url = URL(string: "\(path).\(ext)")!
            return CharactersClientModel(name: result.name!, description: result.description!, imageUrl: url, isImageHidden: true)
        }
    }

    func getCharacters(offset: Int = 0, name: String) {
        isSearching = true
        charactersVewController?.startIndicator()
        marvelApiManager.getCharacters(offset: offset, name: name, completionHandler: { [weak self] result in
            guard let self = self else { return }
            self.charactersVewController?.stopIndicator()
            switch result {
            case let .success(characters):
                let total = characters.charactersData.total
                let offset = characters.charactersData.offset
                self.filteredData += characters.charactersData.charactersResults
                if total == offset {
                    return
                }
                let clientModel = self.setupClientModel(charactersResults: self.filteredData)
                self.charactersVewController?.passData(data: clientModel)
            case let .failure(error):
                self.charactersVewController!.showAlert { self.getCharacters(offset: offset) }
                debugPrint(error)
            }
        })
    }

    func loadMoreData(name: String) {
        isSearching = true
        filteredData = []
        searchTimer?.invalidate()

        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.fetchData(offset: self.filteredData.count, name: name)
                }
            }
        })
    }

    func getCharactersResults() -> [CharactersResult] {
        isSearching ? filteredData : charactersResults
    }

    func fetchDataOnSearch() {
        isSearching ? fetchData(offset: filteredData.count, name: searchText) : fetchData(offset: charactersResults.count)
    }
    
}
