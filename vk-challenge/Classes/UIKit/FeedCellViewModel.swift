//
//  FeedCellViewModel.swift
//  vk-challenge
//
//  Created by basalaev on 10/11/2018.
//  Copyright © 2018 basalaev. All rights reserved.
//

import UIKit

class FeedCellViewModel {

    let post: Post
    var height: CGFloat = 0 {
        didSet {
            print("Update height to \(height)")
        }
    }

    let textStorage: NSTextStorage?
    var textSize: CGSize?

    init(post: Post) {
        self.post = post

        // TODO: Настроить шрифты
        let attributedText = NSAttributedString(string: post.text ?? "", attributes: [.font: UIFont.systemFont(ofSize: 16)])

        let textStorage = NSTextStorage(attributedString: attributedText)
        self.textStorage = textStorage
    }

    func updateLayout(containerSize: CGSize) {
        var height: CGFloat = 0

        if let textStorage = textStorage {
            let textSize = FeedCell.prepare(text: textStorage, containerSize: containerSize)
            height += textSize.height
            self.textSize = textSize
        }

        self.height = height + 12
    }
}
