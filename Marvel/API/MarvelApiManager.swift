//
//  MarvelApiManager.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 10.05.2023.
//

import Alamofire
import AlamofireImage
import Foundation

class MarvelApiManager {
    private let TS = "1"
    private let API_KEY = "7dfc0f333e73358c0783803b12719235"
    private let HASH = "d7383b12bd32ebe70a6fa0d12f1ba6ce"
    typealias Response<T> = (_ result: AFResult<T>) -> Void

    func getCharacters(completionHandler: @escaping (Result<Characters, AFError>) -> Void) {
        performRequest(completion: completionHandler)
    }

    func performRequest(completion: @escaping (Result<Characters, AFError>) -> Void) {
        let path = "https://gateway.marvel.com/v1/public/characters?ts=%@&apikey=%@&hash=%@"
        let urlPath = String(format: path, TS, API_KEY, HASH)
        AF.request(urlPath, method: .get).responseDecodable(of: Characters.self, queue: .main, decoder: JSONDecoder(), completionHandler: { response in
            completion(response.result)
        })
    }

    func downloadImageData(for urlString: String, completion: @escaping (Data?) -> Void) {
        AF.request(urlString, method: .get).responseData(completionHandler: { response in
            switch response.result {
            case let .success(data as Data):
                completion(data)
            case let .failure(error):
                completion(nil)
            default:
                fatalError("received non JSON response")
            }
        })
    }
}
