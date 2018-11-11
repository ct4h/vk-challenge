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
        static let contentMargin: CGFloat = 8
        static let textMargin: CGFloat = 12
        static let headerMargin: CGFloat = 12
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

    let headerView = FeedHeaderView()

    let textView: UITextView = {
        let view = UITextView()
        view.contentInset = .zero
        view.textContainerInset = .zero
        view.isScrollEnabled = false
        view.isEditable = false
        view.backgroundColor = .white
//        view.layer.rasterizationScale = UIScreen.main.scale
//        view.textContainer.maximumNumberOfLines = 6
        return view
    }()

    let footerView = FeedFooterView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(bubbleView)
        bubbleView.addSubview(headerView)
        bubbleView.addSubview(textView)
        bubbleView.addSubview(footerView)
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

//        textView.layer.shouldRasterize = false
        textView.attributedText = nil
    }

    func configureBy(viewModel: FeedCellViewModel) {
        if let headerVM = viewModel.headerVM, let frame = viewModel.headerFrame {
            headerView.frame = frame
            headerView.configureBy(viewModel: headerVM)
            headerView.isHidden = false
        } else {
            headerView.isHidden = true
        }

        if let textStorage = viewModel.textStorage, let frame = viewModel.textFrame {
            textView.frame = frame
            textView.attributedText = textStorage
            textView.isHidden = false
        //textView.layer.shouldRasterize = true
        } else {
            textView.isHidden = true
        }

        if let footerVM = viewModel.footerVM, let frame = viewModel.footerFrame {
            footerView.frame = frame
            footerView.configureBy(viewModel: footerVM)
            footerView.isHidden = false
        } else {
            footerView.isHidden = true
        }
    }

    static func contentViewWidth(containerSize: CGSize) -> CGFloat {
        return containerSize.width - 2 * Constants.contentMargin
    }

    static func headerLayout(containerSize: CGSize) -> CGRect {
        let headerHeight: CGFloat = 36
        let width = contentViewWidth(containerSize: containerSize) - Constants.headerMargin * 2
        return CGRect(x: Constants.headerMargin,
                      y: Constants.headerMargin,
                      width: width,
                      height: headerHeight)
    }

    static func textLayout(text: NSAttributedString, containerSize: CGSize) -> CGRect {
        let width = contentViewWidth(containerSize: containerSize) - Constants.textMargin * 2
        let maxSize = CGSize(width: width, height: containerSize.height)
        let rect = text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        let size = CGSize(width: ceil(rect.width), height: ceil(rect.height))
        return CGRect(origin: CGPoint(x: Constants.textMargin, y: 0), size: size)
    }

    static func footerLayout(containerSize: CGSize) -> CGRect {
        let footerHeight: CGFloat = 48
        let width = contentViewWidth(containerSize: containerSize)
        return CGRect(x: 0, y: 0, width: width, height: footerHeight)
    }
}

