//
//  AttachImageView.swift
//  vk-challenge
//
//  Created by basalaev on 11/11/2018.
//  Copyright © 2018 basalaev. All rights reserved.
//

import UIKit

struct AttachImageViewViewModel {
    let url: URL?
    let size: CGSize
}

class AttachImageView: ImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        isOpaque = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureBy(viewModel: AttachImageViewViewModel) {
        set(imageURL: viewModel.url, placeholder: nil) { image -> UIImage? in
            return image.scaleImage(size: viewModel.size)
        }
    }
}


private extension UIImage {

    func scaleImage(size: CGSize) -> UIImage? {
        let canvasFrame = CGRect(origin: .zero, size: size)
        let scale = UIScreen.main.scale
        let image: UIImage?

        UIGraphicsBeginImageContextWithOptions(size, true, scale)

        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(UIColor.white.cgColor)
            context.fill(canvasFrame)
            var drawRect: CGRect = .zero
            let ratio = min(canvasFrame.width / size.width, canvasFrame.height / size.height);
            drawRect.size.width = canvasFrame.width * ratio;
            drawRect.size.height = canvasFrame.height * ratio;

            // TODO: Position
            draw(in: drawRect, blendMode: .copy, alpha: 1.0)
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
