//
//  Temp.swift
//  vk-challenge
//
//  Created by basalaev on 10/11/2018.
//  Copyright © 2018 basalaev. All rights reserved.
//

import Foundation

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
