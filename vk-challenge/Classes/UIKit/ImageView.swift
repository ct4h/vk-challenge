//
//  ImageView.swift
//  vk-challenge
//
//  Created by basalaev on 11/11/2018.
//  Copyright © 2018 basalaev. All rights reserved.
//

import UIKit

class ImageView: UIImageView {

    var currentTask: URLSessionTask?

    func set(imageURL: URL?, placeholder: UIImage?, preprocess: @escaping (UIImage) -> UIImage?) {
        image = placeholder

        currentTask?.cancel()
        currentTask = nil

        guard let imageURL = imageURL else {
            return
        }

        var urlRequest = URLRequest(url: imageURL)
        urlRequest.cachePolicy = .useProtocolCachePolicy

        currentTask = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            print("Finish request error \(String(describing: error))")

            if self?.currentTask?.originalRequest?.url != imageURL {
                return
            }

            if let data = data, let image = UIImage(data: data) {
                let resultImage = preprocess(image)
                DispatchQueue.main.async {
                    self?.image = resultImage
                }
            }
        }

        currentTask?.resume()
    }
}
