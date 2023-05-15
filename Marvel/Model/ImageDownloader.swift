//
//  ImageDownloader.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 15.05.2023.
//

import UIKit

class ImageDownloader {
    func downloadImageData(for urlString: String, String closure: @escaping (Data?, Error?) -> Void) {
        DispatchQueue.global(qos: .default).async {
            var downloadError: Error?
            var imageData: Data?
            do {
                let url = URL(string: urlString)
                imageData = try Data(contentsOf: url!)
            } catch {
                debugPrint(error)
                downloadError = error
            }

            DispatchQueue.main.async {
                closure(imageData, downloadError)
            }
        }
    }
}
