//
//  MarvelApiManager.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 10.05.2023.
//

import Alamofire
import Foundation

class MarvelApiManager {
    private let baseUrl = "https://gateway.marvel.com/v1/public"
    let networkLogger = NetworkClientLogger()

    var baseParams: [String: Any] = ["ts": "1", "apikey": "7dfc0f333e73358c0783803b12719235", "hash": "d7383b12bd32ebe70a6fa0d12f1ba6ce"]

    func getCharacters(offset: Int?, completionHandler: @escaping (Result<CharactersServerModel, AFError>) -> Void) {
        performRequest(offset: offset, completion: completionHandler)
    }

    func getCharactersByName(offset: Int?, name: String? = nil, completionHandler: @escaping (Result<CharactersServerModel, AFError>) -> Void) {
        performRequest(offset: offset, name: name, completion: completionHandler)
    }

    func getComicsByCharacterId(characterId: Double, completionHandler: @escaping (Result<ComicsServerModel, AFError>) -> Void) {
        performRequest(characterId: characterId, completion: completionHandler)
    }

    func performRequest(offset: Int?, completion: @escaping (Result<CharactersServerModel, AFError>) -> Void) {
        let urlPath = baseUrl + "/characters"
        if offset != nil { baseParams["offset"] = offset }
        baseParams["nameStartsWith"] = nil
        AF.request(urlPath, method: .get, parameters: baseParams).responseDecodable(of: CharactersServerModel.self, queue: .main, decoder: JSONDecoder(), completionHandler: { response in
            self.networkLogger.log(request: response.request, response: response.response, data: response.data, error: response.error, startTime: Date())
            completion(response.result)
        })
    }

    func performRequest(offset: Int?, name: String? = nil, completion: @escaping (Result<CharactersServerModel, AFError>) -> Void) {
        let urlPath = baseUrl + "/characters"
        if offset != nil { baseParams["offset"] = offset }
        if name != nil, name != "" { baseParams["nameStartsWith"] = name }
        AF.request(urlPath, method: .get, parameters: baseParams).responseDecodable(of: CharactersServerModel.self, queue: .main, decoder: JSONDecoder(), completionHandler: { response in
            self.networkLogger.log(request: response.request, response: response.response, data: response.data, error: response.error, startTime: Date())
            completion(response.result)
        })
    }

    func performRequest(characterId: Double, completion: @escaping (Result<ComicsServerModel, AFError>) -> Void) {
        let urlPath = baseUrl + "/characters/\(characterId)/comics"
        AF.request(urlPath, method: .get, parameters: baseParams).responseDecodable(of: ComicsServerModel.self, queue: .main, decoder: JSONDecoder(), completionHandler: { response in
            self.networkLogger.log(request: response.request, response: response.response, data: response.data, error: response.error, startTime: Date())
            completion(response.result)
        })
    }
}
