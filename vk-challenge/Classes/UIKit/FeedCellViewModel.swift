//
//  FeedCellViewModel.swift
//  vk-challenge
//
//  Created by basalaev on 10/11/2018.
//  Copyright © 2018 basalaev. All rights reserved.
//

import UIKit

class FeedCellViewModel {

    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM в hh:mm"
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()

    let post: Post
    let owner: PostOwner?

    var height: CGFloat = 0 {
        didSet {
            print("Update height to \(height)")
        }
    }

    let headerVM: FeedHeaderViewModel?

    let textStorage: NSTextStorage?
    var textSize: CGSize?

    init(post: Post, owner: PostOwner?) {
        self.post = post
        self.owner = owner

        if let owner = owner {
            // TODO: Фото опциональное
            let imageURL = URL(string: owner.photo_100)
            let date = Date(timeIntervalSince1970: TimeInterval(post.date))
            let dateString = FeedCellViewModel.dateFormatter.string(from: date)
            headerVM = FeedHeaderViewModel(imageURL: imageURL, name: owner.name, date: dateString)
        } else {
            headerVM = nil
        }

        // TODO: Настроить шрифты
        // TODO: Форматирование тегов, и финаьная настройка текста
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

        let headerHeight: CGFloat = 36
        let margin: CGFloat = 12
        let spacing: CGFloat = 10
        let bottomShadowOffset: CGFloat = 12
        self.height = height + headerHeight + margin + spacing + bottomShadowOffset
    }
}
