//
//  ApiClient.swift
//  vk-challenge
//
//  Created by basalaev on 10/11/2018.
//  Copyright © 2018 basalaev. All rights reserved.
//

import Foundation

enum ApiRequest {
    case newsfeed(startFrom: String?)

    var method: String {
        switch self {
        case .newsfeed:
            return "newsfeed.get"
        }
    }

    var parameters: [String: String] {
        switch self {
        case let .newsfeed(startFrom):
            var parameters: [String: String] = [:]
            if let startFrom = startFrom {
                parameters["start_from"] = startFrom
            }
            return parameters
        }
    }

    var httpMethod: String {
        switch self {
        case .newsfeed:
            return "POST"
        }
    }
}

struct ApiResponse<T: Decodable>: Decodable {
    let response: T?
}

class ApiClient {

    let accessToken: String

    init(accessToken: String) {
        self.accessToken = accessToken
    }

    private var additionalParameters: [String: String] {
        return ["access_token" : accessToken,
                "v": "5.87"]
    }

    func send<T: Decodable>(request: ApiRequest, complitionBlock: @escaping (T?) -> Void) -> URLSessionTask? {
        let baseURL = "https://api.vk.com/method/"
        let session = URLSession.shared

        var allParams: [String] = []
        request.parameters.forEach { (key, value) in
            allParams.append("\(key)=\(value)")
        }
        additionalParameters.forEach { (key, value) in
            allParams.append("\(key)=\(value)")
        }

        let urlPath = baseURL + request.method + "?" + allParams.joined(separator: "&")

        guard let url = URL(string: urlPath) else {
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod

        print("start \(urlRequest)")
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            print("Finish request error \(String(describing: error))")

            if let data = data {

//                if let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
//                    print("\(jsonData)")
//                }

                do {
                    let parsedData = try JSONDecoder().decode(ApiResponse<T>.self, from: data)
                    complitionBlock(parsedData.response)
//                    print("\(parsedData)")
                } catch {
                    print("Error \(error)")
                }
            }
        }

        return task
    }
}
