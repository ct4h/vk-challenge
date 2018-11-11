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

    private var stackView: UIStackView?
    private let likesButton = FeedFooterButton()
    private let commentsButton = FeedFooterButton()
    private let repostsButton = FeedFooterButton()
    private let viewsButton = FeedFooterButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .red

//        let stackView = UIStackView(arrangedSubviews: [likesButton,
//                                                       commentsButton,
//                                                       repostsButton])
//        stackView.distribution = .equalSpacing
//        stackView.axis = .horizontal
//        stackView.alignment = .fill
//        stackView.spacing = 10

        [likesButton, commentsButton, repostsButton, viewsButton].forEach({ button in
            button.translatesAutoresizingMaskIntoConstraints = false
            addSubview(button)

            NSLayoutConstraint.activate([
                button.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 2.5)
            ])
        })

        likesButton.setImage(UIImage(named: "Like_outline_24"), for: .normal)
        commentsButton.setImage(UIImage(named: "Comment_outline_24"), for: .normal)
        repostsButton.setImage(UIImage(named: "Share_outline_24"), for: .normal)
        viewsButton.setImage(UIImage(named: "View_20"), for: .normal)


        viewsButton.isEnabled = false

        NSLayoutConstraint.activate([
            likesButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 19),
            commentsButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 103),
            repostsButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 187),
            viewsButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureBy(viewModel: FeedFooterViewModel) {
        likesButton.setTitle(viewModel.likes, for: .normal)
        repostsButton.setTitle(viewModel.reposts, for: .normal)

        // TODO: Констрейнт
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
    }
}

class FeedFooterButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .blue

        contentEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 10)
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
