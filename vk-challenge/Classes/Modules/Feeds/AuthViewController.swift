//
//  AuthViewController.swift
//  vk-challenge
//
//  Created by basalaev on 11/11/2018.
//  Copyright © 2018 basalaev. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    let activityIndicator = UIActivityIndicatorView(style: .gray)

    var sendAuthRequest: Bool = false
    let authManager = AuthManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        authManager.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if sendAuthRequest {
            return
        }

        sendAuthRequest = true
        authManager.updateToken()
    }
}

extension AuthViewController: AuthManagerDelegate {

    func completeUpdate(token: String?) {
        let controller = FeedsViewController(accessToken: token)
        navigationController?.setViewControllers([controller], animated: true)
    }

    func needDisplay(viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
}
