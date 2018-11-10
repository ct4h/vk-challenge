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

    let cellHeight: [CGFloat] = [80, 100, 150, 240, 300, 400, 600, 1200, 1800, 600, 400, 300, 240, 40]

    override func viewDidLoad() {
        super.viewDidLoad()

        authManager.delegate = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.frame = view.bounds
        view.addSubview(tableView)

        tableView.separatorColor = .red
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        authManager.updateToken()
    }
}

extension FeedsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellHeight.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID") else {
            fatalError("")
        }
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "text"
        return cell
    }
}

extension FeedsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight[indexPath.row]
    }
}

extension FeedsViewController: AuthManagerDelegate {

    func completeUpdate(token: String?) {
        apiClient.accessToken = token

        apiClient.send(request: .newsfeed) { (data: NewsFeedResponse?) in
            print("[\(Thread.isMainThread ? "MAIN": "BACK")] end request")
        }
    }
}
