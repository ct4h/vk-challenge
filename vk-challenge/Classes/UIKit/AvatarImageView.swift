//
//  AvatarImageView.swift
//  vk-challenge
//
//  Created by basalaev on 11/11/2018.
//  Copyright © 2018 basalaev. All rights reserved.
//

import UIKit

class AvatarImageView: ImageView {

    private struct Constants {
        static let size = CGSize(width: 36, height: 36)
    }

    static let placeholder = UIImage.defaultImage(size: Constants.size)

    func set(imageURL: URL?) {
        super.set(imageURL: imageURL, placeholder: AvatarImageView.placeholder) { originalImage -> UIImage? in
            return originalImage.circleMasked(size: Constants.size)
        }
    }
}

private extension UIImage {

    static func defaultImage(size: CGSize) -> UIImage? {
        let canvasFrame = CGRect(origin: .zero, size: size)
        let scale = UIScreen.main.scale
        let image: UIImage?

        UIGraphicsBeginImageContextWithOptions(size, true, scale)

        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(UIColor.white.cgColor)
            context.fill(canvasFrame)

            let borderWidth: CGFloat = 0.5
            let borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08)
            let borderPath = UIBezierPath(ovalIn: canvasFrame.insetBy(dx: borderWidth, dy: borderWidth))
            borderPath.lineWidth = borderWidth
            context.setStrokeColor(borderColor.cgColor)
            context.addPath(borderPath.cgPath)
            context.drawPath(using: .stroke)
            image = UIGraphicsGetImageFromCurrentImageContext()
        } else {
            image = nil
        }

        UIGraphicsEndImageContext()

        return image
    }

    func circleMasked(size: CGSize) -> UIImage? {
        let canvasFrame = CGRect(origin: .zero, size: size)
        let scale = UIScreen.main.scale
        var image: UIImage? = self

        UIGraphicsBeginImageContextWithOptions(size, true, scale)

        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(UIColor.white.cgColor)
            context.fill(canvasFrame)
            context.saveGState()

            context.addPath(UIBezierPath(ovalIn: canvasFrame).cgPath)
            context.clip()
            draw(in: canvasFrame, blendMode: .copy, alpha: 1.0)

            context.restoreGState()

            let borderWidth: CGFloat = 0.5
            let borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08)
            let borderPath = UIBezierPath(ovalIn: canvasFrame.insetBy(dx: borderWidth, dy: borderWidth))
            borderPath.lineWidth = borderWidth
            context.setStrokeColor(borderColor.cgColor)
            context.addPath(borderPath.cgPath)
            context.drawPath(using: .stroke)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }

        UIGraphicsEndImageContext()

        return image
    }
}
