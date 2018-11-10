//
//  AuthManager.swift
//  vk-challenge
//
//  Created by basalaev on 10/11/2018.
//  Copyright © 2018 basalaev. All rights reserved.
//

import Foundation
import VKSdkFramework

protocol AuthManagerDelegate: class {
    func completeUpdate(token: String?)
}

class AuthManager: NSObject {

    var accessToken: String?
    weak var delegate: AuthManagerDelegate?

    override init() {
        super.init()
        VKSdk.initialize(withAppId: "6747661")?.register(self)
    }

    private var permissions: [Any] {
        return ["wall", "friends"]
    }

    func updateToken() {
        accessToken = nil

        VKSdk.wakeUpSession(permissions) { [weak self] state, error in
            switch state {
            case .authorized:
                if let token = VKSdk.accessToken() {
                    self?.accessToken = token.accessToken
                    self?.delegate?.completeUpdate(token: token.accessToken)
                }
            default:
                self?.login()
                return
            }
        }
    }

    private func login() {
        VKSdk.authorize(permissions)
    }
}

extension AuthManager: VKSdkDelegate {

    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        accessToken = result.token.accessToken
        delegate?.completeUpdate(token: accessToken)
    }

    func vkSdkUserAuthorizationFailed() {
        print("Failed")
    }
}
