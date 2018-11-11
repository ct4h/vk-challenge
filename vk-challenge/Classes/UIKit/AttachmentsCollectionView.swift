//
//  AttachmentsCollectionView.swift
//  vk-challenge
//
//  Created by basalaev on 11/11/2018.
//  Copyright © 2018 basalaev. All rights reserved.
//

import UIKit

class AttachmentsCollectionView: UIView {

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        isOpaque = true

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.isOpaque = true
        collectionView.register(AttachmentCell.self, forCellWithReuseIdentifier: "CellID")
        addSubview(collectionView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        collectionView.frame = bounds
    }

    var viewModels: [AttachImageViewViewModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
}

extension AttachmentsCollectionView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath)

        if let attachmentCell = cell as? AttachmentCell, let viewModel = viewModels?[indexPath.item] {
            attachmentCell.configureBy(viewModel: viewModel)
        }

        return cell
    }
}

extension AttachmentsCollectionView: UICollectionViewDelegate {}

extension AttachmentsCollectionView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let viewModel = viewModels?[indexPath.item] {
            return viewModel.size
        } else {
            return .zero
        }
    }
}

//extension AttachmentsCollectionView: UIScrollViewDelegate {
//    // TODO: Сохранять позицию прокрутки
//}

private class AttachmentCell: UICollectionViewCell {
    let imageView = AttachImageView(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.cancelLoad()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }

    func configureBy(viewModel: AttachImageViewViewModel) {
        imageView.configureBy(viewModel: viewModel)
    }
}
