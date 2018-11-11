//
//  FeedFooterView.swift
//  vk-challenge
//
//  Created by basalaev on 11/11/2018.
//  Copyright © 2018 basalaev. All rights reserved.
//

import UIKit

struct FeedFooterViewModel {
    let likes: String
    let comments: String?
    let reposts: String
    let views: String?
}

class FeedFooterView: UIView {

    private let likesButton = FeedFooterButton()
    private let commentsButton = FeedFooterButton()
    private let repostsButton = FeedFooterButton()
    private let viewsButton = FeedFooterButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        isOpaque = true

        [likesButton, commentsButton, repostsButton, viewsButton].forEach({ addSubview($0) })

        likesButton.setImage(UIImage(named: "Like_outline_24"), for: .normal)
        commentsButton.setImage(UIImage(named: "Comment_outline_24"), for: .normal)
        repostsButton.setImage(UIImage(named: "Share_outline_24"), for: .normal)
        viewsButton.setImage(UIImage(named: "View_20"), for: .normal)

        viewsButton.isEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateLayout() {
        let margin: CGFloat = 16
        let spacing: CGFloat = 10
        let buttonCount: CGFloat = 4

        let contentWidth = bounds.width - 2 * margin
        let buttonWidth = ceil((contentWidth - (buttonCount - 1) * spacing) / buttonCount)

        var buttons: [FeedFooterButton] = [likesButton]
        if !commentsButton.isHidden {
            buttons.append(commentsButton)
        }
        buttons.append(repostsButton)

        var originX = margin

        for button in buttons {
            let size = button.sizeThatFits(bounds.size)
            button.frame = CGRect(origin: CGPoint(x: originX, y: ((bounds.height - size.height) / 2.0) + 2.5), size: size)
            originX += buttonWidth + spacing
        }

        if !viewsButton.isHidden {
            let size = viewsButton.sizeThatFits(bounds.size)
            viewsButton.frame = CGRect(origin: CGPoint(x: bounds.width - margin - size.width, y: ((bounds.height - size.height) / 2.0) + 2.5), size: size)
        }
    }

    func configureBy(viewModel: FeedFooterViewModel) {
        likesButton.setTitle(viewModel.likes, for: .normal)
        repostsButton.setTitle(viewModel.reposts, for: .normal)

        if let comments = viewModel.comments {
            commentsButton.setTitle(comments, for: .normal)
            commentsButton.isHidden = false
        } else {
            commentsButton.isHidden = true
        }

        if let views = viewModel.views {
            viewsButton.setTitle(views, for: .normal)
            viewsButton.isHidden = false
        } else {
            viewsButton.isHidden = true
        }

        updateLayout()
    }
}

class FeedFooterButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: -7)

        if let label = titleLabel {
            label.font = UIFont(name: "SFProText-Medium", size: 14)
        }

        setTitleColor(UIColor(red: 0.5, green: 0.55, blue: 0.6, alpha: 1), for: .normal)
        tintColor = UIColor(red: 0.5, green: 0.55, blue: 0.6, alpha: 1)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
