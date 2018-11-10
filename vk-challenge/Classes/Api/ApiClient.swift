//
//  ApiClient.swift
//  vk-challenge
//
//  Created by basalaev on 10/11/2018.
//  Copyright © 2018 basalaev. All rights reserved.
//

import Foundation

enum ApiRequest {
    case newsfeed

    var method: String {
        switch self {
        case .newsfeed:
            return "newsfeed.get"
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

    var accessToken: String?

    func send<T: Decodable>(request: ApiRequest, complitionBlock: @escaping (T?) -> Void) {
        let baseURL = "https://api.vk.com/method/"
        let session = URLSession.shared

        guard let url = URL(string: baseURL + request.method + "?access_token=\(accessToken ?? "")&v=5.87") else {
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod

        print("start \(urlRequest)")
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            print("Finish request error \(String(describing: error))")

            if let data = data {

                if let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    print("\(jsonData)")
                }

                do {
                    let parsedData = try JSONDecoder().decode(ApiResponse<T>.self, from: data)
                    print("\(parsedData)")
                } catch {
                    print("Error \(error)")
                }
            }
            complitionBlock(nil)
        }

        task.resume()
    }
}


/*
 func retrieveUsers(_ completionBlock: @escaping (_ success: Bool, _ error: NSError?) -> ()) {
 let urlString = ... // Users Web Service URL
 let session = URLSession.shared

 guard let url = URL(string: urlString) else {
 completionBlock(false, nil)
 return
 }
 let task = session.dataTask(with: url) { [weak self] (data, response, error) in
 guard let strongSelf = self else { return }
 guard let data = data else {
 completionBlock(false, error as NSError?)
 return
 }
 let error = ... // Define a NSError for failed parsing
 if let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: AnyObject]] {
 guard let jsonData = jsonData else {
 completionBlock(false,  error)
 return
 }
 var users = [User?]()
 for json in jsonData {
 if let user = UserViewModelController.parse(json) {
 users.append(user)
 }
 }

 strongSelf.viewModels = UserViewModelController.initViewModels(users)
 completionBlock(true, nil)
 } else {
 completionBlock(false, error)
 }
 }
 task.resume()
 }
 */
