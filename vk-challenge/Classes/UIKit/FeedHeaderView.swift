//
//  FeedHeaderView.swift
//  vk-challenge
//
//  Created by basalaev on 11/11/2018.
//  Copyright © 2018 basalaev. All rights reserved.
//

import UIKit

struct FeedHeaderViewModel {
    let imageURL: URL?
    let name: String
    let date: String
}

class FeedHeaderView: UIView {

    let imageView = AvatarImageView()
    let nameLabel = UILabel()
    let dateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        isOpaque = true
        backgroundColor = .white

        [imageView, nameLabel, dateLabel].forEach({ addSubview($0) })

        imageView.backgroundColor = .white
        imageView.isOpaque = true

        nameLabel.textColor = UIColor(red: 0.17, green: 0.18, blue: 0.18, alpha: 1)
        nameLabel.font = UIFont(name: "SFProText-Medium", size: 14)
        nameLabel.backgroundColor = .white
        nameLabel.isOpaque = true

        dateLabel.textColor = UIColor(red: 0.5, green: 0.55, blue: 0.6, alpha: 1)
        dateLabel.font = UIFont(name: "SFProText-Regular", size: 12)
        dateLabel.backgroundColor = .white
        dateLabel.isOpaque = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        imageView.frame = CGRect(x: 0, y: 0, width: 36, height: 36)

        let labelOriginX = imageView.frame.maxX + 10
        let labelWidth = bounds.width - labelOriginX
        nameLabel.frame = CGRect(x: labelOriginX, y: 2, width: labelWidth, height: 17)
        dateLabel.frame = CGRect.init(x: labelOriginX, y: nameLabel.frame.maxY + 1, width: labelWidth, height: 15)
    }

    func configureBy(viewModel: FeedHeaderViewModel) {
        imageView.set(imageURL: viewModel.imageURL)
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
    }
}
