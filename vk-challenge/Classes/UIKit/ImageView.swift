//
//  ImageView.swift
//  vk-challenge
//
//  Created by basalaev on 11/11/2018.
//  Copyright © 2018 basalaev. All rights reserved.
//

import UIKit

class ImageView: UIImageView {

    private var currentTask: URLSessionTask?

    func set(imageURL: URL?, placeholder: UIImage?, preprocess: @escaping (UIImage) -> UIImage?) {
        image = placeholder
        cancelLoad()

        guard let imageURL = imageURL else {
            return
        }

        var urlRequest = URLRequest(url: imageURL)
        urlRequest.cachePolicy = .useProtocolCachePolicy

        currentTask = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
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

    func cancelLoad() {
        currentTask?.cancel()
        currentTask = nil
        image = nil
    }
}
