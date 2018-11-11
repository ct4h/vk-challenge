//
//  UIView+.swift
//  vk-challenge
//
//  Created by basalaev on 11/11/2018.
//  Copyright © 2018 basalaev. All rights reserved.
//

import UIKit

extension UIView {

    func addFadeAnimation(duration: TimeInterval = 0.25) {
        let key = "animationFade"

        let animation = CATransition()
        animation.duration = duration
        animation.type = CATransitionType.fade

        removeFadeAnimation()
        layer.add(animation, forKey: key)
    }

    func removeFadeAnimation() {
        let key = "animationFade"
        layer.removeAnimation(forKey: key)
    }
}
