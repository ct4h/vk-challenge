//
//  FeedCell.swift
//  vk-challenge
//
//  Created by basalaev on 10/11/2018.
//  Copyright © 2018 basalaev. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    private struct Constants {
        static let textMargin: CGFloat = 20
    }

    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor(red: 0.39, green: 0.4, blue: 0.44, alpha: 0.07).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 18
        view.layer.shadowOffset = CGSize(width: 0, height: 24)
        return view
    }()

    let textView: UITextView = {
        let view = UITextView()
        view.contentInset = .zero
        view.textContainerInset = .zero
        view.isScrollEnabled = false
        view.isEditable = false
        view.backgroundColor = .white
//        view.textContainer.maximumNumberOfLines = 6
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(bubbleView)
        contentView.addSubview(textView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        var bubbleViewFrame = contentView.bounds.insetBy(dx: 8, dy: 0)
        bubbleViewFrame.size.height -= 12
        bubbleView.frame = bubbleViewFrame
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        textView.attributedText = nil
    }

    func configureBy(viewModel: FeedCellViewModel) {
        if let textStorage = viewModel.textStorage, let textSize = viewModel.textSize {
            textView.frame = CGRect(x: Constants.textMargin, y: 0, width: textSize.width, height: textSize.height)
            textView.attributedText = textStorage
            textView.isHidden = false
        } else {
            textView.isHidden = true
        }
    }

    static func prepare(text: NSAttributedString, containerSize: CGSize) -> CGSize {
        let maxSize = CGSize(width: containerSize.width - 2 * Constants.textMargin, height: containerSize.height)
        let rect = text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        let width = ceil(rect.width)
        let height = ceil(rect.height)
        return CGSize(width: width, height: height)
    }
}

