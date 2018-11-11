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
    let owner: PostOwner?

    var height: CGFloat = 0

    private(set) var contentFrame: CGRect = .zero

    let headerVM: FeedHeaderViewModel?
    private(set) var headerFrame: CGRect?

    let textStorage: NSTextStorage?
    private(set) var textFrame: CGRect?

    let footerVM: FeedFooterViewModel?
    private(set) var footerFrame: CGRect?

    private(set) var attachmentVMs: [AttachImageViewViewModel]?
    private(set) var attachmentsFrame: CGRect?

    init(post: Post, owner: PostOwner?) {
        self.post = post
        self.owner = owner

        if let owner = owner {
            let date = DateFormatter.humanDateString(timeInterval: TimeInterval(post.date))
            headerVM = FeedHeaderViewModel(imageURL: owner.photo_100?.url, name: owner.name, date: date)
        } else {
            headerVM = nil
        }

        if let text = post.text {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.alignment = .left

            let attributes: [NSAttributedString.Key : Any] = [
                .font: UIFont(name: "SFProText-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15),
                .foregroundColor: UIColor(red: 0.17, green: 0.18, blue: 0.19, alpha: 1),
                .paragraphStyle: paragraphStyle
            ]

            let attributedText = NSAttributedString(string: text, attributes: attributes)
            self.textStorage = NSTextStorage(attributedString: attributedText)
        } else {
            self.textStorage = nil
        }

        if let likes = post.likes, let repost = post.reposts {
            footerVM = FeedFooterViewModel(likes: likes.count.userFriendly,
                                           comments: post.comments?.count.userFriendly,
                                           reposts: repost.count.userFriendly,
                                           views: post.views?.count.userFriendly)
        } else {
            footerVM = nil
        }
    }

    func updateLayout(containerSize: CGSize) {
        var height: CGFloat = 0
        let space: CGFloat = 10

        if headerVM != nil {
            let headerFrame = FeedCell.headerLayout(containerSize: containerSize)
            height = headerFrame.maxY
            self.headerFrame = headerFrame
        }

        if let textStorage = textStorage {
            var textFrame = FeedCell.textLayout(text: textStorage, containerSize: containerSize)
            textFrame.origin.y = height + space
            height = textFrame.maxY
            self.textFrame = textFrame
        }

        if let attachments = post.attachments {
            let photoAttachments = attachments.filter({ $0.type == .photo })
            let contentWidth = FeedCell.attachmentsWidth(containerSize: containerSize, count: photoAttachments.count)
            var attachmentVMs: [AttachImageViewViewModel] = []

            for attachment in photoAttachments {
                if let size = attachment.photo?.size(containerWidth: contentWidth) {
                    let url = URL(string: size.url)
                    let scaledSize = size.scaledSizeBy(containerWidth: contentWidth)
                    let viewModel = AttachImageViewViewModel(url: url, size: scaledSize)
                    attachmentVMs.append(viewModel)
                }
            }

            if !attachmentVMs.isEmpty {
                let fullContentWidth = FeedCell.contentViewWidth(containerSize: containerSize)
                let attachment = attachmentVMs[0]
                let frame = CGRect(origin: CGPoint(x: 0, y: height + space),
                                   size: CGSize(width: fullContentWidth, height: attachment.size.height))
                attachmentsFrame = frame
                self.attachmentVMs = attachmentVMs
                height = frame.maxY
            }
        }

        if footerVM != nil {
            var footerFrame = FeedCell.footerLayout(containerSize: containerSize)
            footerFrame.origin.y = height
            height = footerFrame.maxY
            self.footerFrame = footerFrame
        }

        let bottomOffset: CGFloat = 12
        contentFrame = FeedCell.containerLayout(containerSize: containerSize, contentHeight: height)
        self.height = contentFrame.height + bottomOffset
    }
}

private extension Int {

    var userFriendly: String {
        if self == 0 {
            return ""
        } else if self >= 1_000_000 {
            return "999+К"
        } else if self < 1_000 {
            return String(self)
        } else {
            return "\(self / 1_000)K"
        }
    }
}

private extension DateFormatter {

    private static let currentYear: Int = {
        return Calendar.current.component(.year, from: Date())
    }()

    private static let defaultDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = NSLocalizedString("date-formatter.default-format", comment: "")
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()

    private static let yearDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = NSLocalizedString("date-formatter.year-format", comment: "")
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()

    static func humanDateString(timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let year = Calendar.current.component(.year, from: date)

        let dateFormatter: DateFormatter
        if year < DateFormatter.currentYear {
            dateFormatter = yearDateFormatter
        } else {
            dateFormatter = defaultDateFormatter
        }

        return dateFormatter.string(from: date).lowercased()
    }
}

private extension String {

    var url: URL? {
        return URL(string: self)
    }
}

private extension Photo {

    func size(containerWidth: CGFloat) -> AttachmentSize? {
        let scaledWidth = containerWidth * UIScreen.main.scale
        let size = sizes.first(where: { CGFloat($0.width) >= scaledWidth })
        return size ?? sizes.last
    }
}

private extension AttachmentSize {

    func scaledSizeBy(containerWidth: CGFloat) -> CGSize {
        let ratio = CGFloat(width) / CGFloat(height)
        let scaledHeight = ceil(containerWidth / ratio)
        return CGSize(width: containerWidth, height: scaledHeight)
    }
}
