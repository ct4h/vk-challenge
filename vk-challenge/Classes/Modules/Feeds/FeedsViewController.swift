//
//  FeedsViewController.swift
//  vk-challenge
//
//  Created by basalaev on 10/11/2018.
//  Copyright © 2018 basalaev. All rights reserved.
//

import UIKit

class FeedsViewController: UIViewController {

    var apiClient: ApiClient!
    let paginationManager = PaginationManager()
    let tableView = UITableView()
    let refreshControl = UIRefreshControl()
    let indicatorView = BottomIndicationView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))

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

    init(accessToken: String) {
        super.init(nibName: nil, bundle: nil)

        apiClient = ApiClient(accessToken: accessToken)
        paginationManager.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.addSublayer(gradientBackground)

        tableView.register(FeedCell.self, forCellReuseIdentifier: "CellID")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.frame = view.bounds
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.tableFooterView = indicatorView
        view.addSubview(tableView)

        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        refreshControl.tintColor = UIColor(red: 0.56, green: 0.58, blue: 0.6, alpha: 1)
        tableView.addSubview(refreshControl)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if viewModels.isEmpty {
            paginationManager.refreshData()
        }
    }

    @objc
    private func handleRefreshControl() {
        print("handleRefreshControl")
        paginationManager.refreshData()
    }
}

extension FeedsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
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
        paginationManager.loadNextData(indexPath: indexPath)
    }
}

// MARK: - API

extension FeedsViewController: PaginationManagerDelegate {

    func performRequest(next: String?, completion: @escaping (String?, Int) -> Void) -> URLSessionTask? {
        indicatorView.countPosts = nil

        return apiClient.send(request: .newsfeed(startFrom: next)) { [weak self] (data: NewsFeedResponse?) in
            print("[\(Thread.isMainThread ? "MAIN": "BACK")] end request")
            self?.process(data: data, force: next == nil)

            if let data = data {
                DispatchQueue.main.async {
                    completion(data.next_from, data.items.count)
                }
            }
        }
    }

    private func process(data: NewsFeedResponse?, force: Bool) {
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
            if force {
                self?.viewModels = newPosts
            } else {
                self?.viewModels.append(contentsOf: newPosts)
            }

            self?.tableView.reloadData()

            if data.next_from == nil {
                self?.indicatorView.countPosts = self?.viewModels.count
            }

            if force {
                self?.refreshControl.endRefreshing()
                self?.tableView.addFadeAnimation()
            }
        }
    }
}

protocol PaginationManagerDelegate: class {
    func performRequest(next: String?, completion: @escaping (String?, Int) -> Void) -> URLSessionTask?
}

class PaginationManager {

    weak var delegate: PaginationManagerDelegate?

    private var isLoading: Bool = false
    private var isEnd: Bool = false
    private var offset: Int = 0
    private var next_from: String?
    private var currentTask: URLSessionTask? {
        didSet {
            currentTask?.resume()
        }
    }

    func refreshData() {
        loadData(force: true)
    }

    func loadNextData(indexPath: IndexPath) {
        if isEnd {
            return
        }

        if isLoading {
            return
        }

        if indexPath.row < offset {
            return
        }

        isLoading = true
        loadData(force: false)
    }

    private func loadData(force: Bool) {
        isLoading = true
        currentTask?.cancel()
        currentTask = delegate?.performRequest(next: force ? nil : next_from, completion: { [weak self] next, count in
            self?.isEnd = next == nil
            self?.next_from = next
            if force {
                self?.offset = 0
            }

            self?.offset += count / 2

            self?.isLoading = false
        })
    }
}
