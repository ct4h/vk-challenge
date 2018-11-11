//
//  FeedsViewController.swift
//  vk-challenge
//
//  Created by basalaev on 10/11/2018.
//  Copyright © 2018 basalaev. All rights reserved.
//

import UIKit

class FeedsViewController: UIViewController {

    let authManager = AuthManager()
    let apiClient = ApiClient()
    let tableView = UITableView()

    var viewModels: [FeedCellViewModel] = []

    let gradientBackground: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1).cgColor,
            UIColor(red: 0.92, green: 0.93, blue: 0.94, alpha: 1).cgColor
        ]
        layer.locations = [0, 1]
        layer.startPoint = CGPoint(x: 0.5, y: 0.25)
        layer.endPoint = CGPoint(x: 0.5, y: 0.75)
        layer.contentsScale = UIScreen.main.scale
        layer.frame = UIScreen.main.bounds
        return layer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        authManager.delegate = self

        view.layer.addSublayer(gradientBackground)

        tableView.register(FeedCell.self, forCellReuseIdentifier: "CellID")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.frame = view.bounds
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        authManager.updateToken()
    }
}

extension FeedsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
//
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) else {
//            fatalError("")
//        }
//
//        return cell
    }
}

extension FeedsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModels[indexPath.row].height
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? FeedCell else {
            return
        }

        cell.configureBy(viewModel: viewModels[indexPath.row])
    }
}

extension FeedsViewController: AuthManagerDelegate {

    func completeUpdate(token: String?) {
        apiClient.accessToken = token

        apiClient.send(request: .newsfeed) { [weak self] (data: NewsFeedResponse?) in
            print("[\(Thread.isMainThread ? "MAIN": "BACK")] end request")
            self?.process(data: data)
        }
    }

    private func process(data: NewsFeedResponse?) {
        guard let data = data else {
            return
        }

        var newPosts: [FeedCellViewModel] = []

        let containerSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat.greatestFiniteMagnitude)

        data.items.forEach { post in
            let owner: PostOwner?

            if post.source_id < 0 {
                let groupID = abs(post.source_id)
                owner = data.groups.first(where: { $0.id == groupID })
            } else {
                owner = data.profiles.first(where: { $0.id == post.source_id })
            }

            let viewModel = FeedCellViewModel(post: post, owner: owner)
            viewModel.updateLayout(containerSize: containerSize)
            newPosts.append(viewModel)
        }

        DispatchQueue.main.async { [weak self] in
            self?.viewModels.append(contentsOf: newPosts)
            self?.tableView.reloadData()
        }
    }
}
