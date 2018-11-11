//
//  BottomIndicationView.swift
//  vk-challenge
//
//  Created by basalaev on 11/11/2018.
//  Copyright © 2018 basalaev. All rights reserved.
//

import UIKit

class BottomIndicationView: UIView {

    private let label = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .gray)

    var countPosts: Int? = 0 {
        didSet {
            if let count = countPosts {
                label.isHidden = false
                activityIndicator.isHidden = true
                // TODO: плурал
                label.text = String(count)
            } else {
                label.isHidden = true
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear

        label.textColor = UIColor(red: 0.56, green: 0.58, blue: 0.6, alpha: 1)
        label.font = UIFont(name: "SFProText-Regular", size: 13)

        activityIndicator.tintColor = UIColor(red: 0.56, green: 0.58, blue: 0.6, alpha: 1)
        activityIndicator.hidesWhenStopped = true

        [label, activityIndicator].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)

            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: centerXAnchor),
                view.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
