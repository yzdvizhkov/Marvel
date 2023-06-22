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
    func fetchDataByName(offset: Int, name: String)
    func fetchDataOnSearch()
    func loadMoreData(name: String)
    func clearResults()
}

class CharactersPresenter: PresenterInput {
    func clearResults() {
        isSearching = false
        charactersClientModel = setupClientModel(charactersResults: charactersResults)
        charactersVewController?.passData(data: charactersClientModel)
        charactersVewController?.updateTable()
    }

    func fetchInitialData() {
        getCharacters()
    }

    func fetchData(offset: Int) {
        getCharacters(offset: offset)
    }

    func fetchDataByName(offset: Int, name: String) {
        getCharacters(offset: offset, name: name)
    }

    weak var charactersVewController: ViewControllerInput?
    let marvelApiManager = MarvelApiManager()
    var charactersResults: [CharactersResult] = []
    var filteredData: [CharactersResult] = []
    var searchText: String = ""
    var searchTimer: Timer?
    var isSearching = false
    var charactersClientModel: [CharactersClientModel] = []
    var filteredClientModel: [CharactersClientModel] = []
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
                self.charactersClientModel = self.setupClientModel(charactersResults: self.charactersResults)
                self.charactersVewController?.passData(data: self.charactersClientModel)
                if total == offset {
                    return
                }
                self.charactersVewController?.updateTable()

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
        marvelApiManager.getCharactersByName(offset: offset, name: name, completionHandler: { [weak self] result in
            guard let self = self else { return }
            self.charactersVewController?.stopIndicator()
            switch result {
            case let .success(characters):
                let total = characters.charactersData.total
                let offset = characters.charactersData.offset
                self.filteredData += characters.charactersData.charactersResults
                self.filteredClientModel = self.setupClientModel(charactersResults: self.filteredData)
                self.charactersVewController?.passData(data: self.filteredClientModel)

                if total == offset {
                    return
                }
                self.charactersVewController?.updateTable()

            case let .failure(error):
                self.charactersVewController!.showAlert { self.getCharacters(offset: offset) }
                debugPrint(error)
            }
        })
    }

    func loadMoreData(name: String) {
        isSearching = true
        filteredData = []
        filteredClientModel = setupClientModel(charactersResults: filteredData)
        searchTimer?.invalidate()

        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.fetchDataByName(offset: self.filteredClientModel.count, name: name)
                }
            }
        })
    }

    func fetchDataOnSearch() {
        isSearching ? fetchDataByName(offset: filteredClientModel.count, name: searchText) : fetchData(offset: charactersClientModel.count)
    }
}
