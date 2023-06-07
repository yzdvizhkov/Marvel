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
    func getCharactersResults() -> [CharactersResult]
    func clearResults()
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
                self.charactersVewController?.updateTable()

            case let .failure(error):
                self.charactersVewController!.showAlert { self.getCharacters(offset: offset) }
                debugPrint(error)
            }
        })
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
        searchTimer?.invalidate()

        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.fetchData(offset: self.filteredData.count, name: name)
                    self.charactersVewController?.updateTable()
                }
            }
        })
    }

    func getCharactersResults() -> [CharactersResult] {
        isSearching == true ? filteredData : charactersResults
    }

    func fetchDataOnSearch() {
        isSearching == true ? fetchData(offset: filteredData.count, name: searchText) : fetchData(offset: charactersResults.count)
    }
}
