//
//  ViewController.swift
//  SlashRSlashSwift
//
//  Created by Spencer Alderson on 2019-08-08.
//  Copyright © 2019 Spencer Alderson. All rights reserved.
//

import UIKit

final class ArticleListViewController: UIViewController, NetworkServiceInjectable {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var articles: [Article]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        fetchArticles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        self.tableView.deselectRow(at: selectedIndexPath, animated: true)
    }
    
    private func setUp() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Swift News"
        self.tableView.rowHeight = UITableView.automaticDimension
        setupRefresher()
    }
    
    private func setupRefresher() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    @objc private func refresh() {
        self.fetchArticles()
    }
    
    private func endRefreshing() {
        self.tableView.refreshControl?.endRefreshing()
    }
    
    private func fetchArticles() {
        self.networkService.fetchArticles { result in
            switch result {
            case .success(let articles):
                DispatchQueue.main.async {
                    self.articles = articles
                    self.endRefreshing()
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.endRefreshing()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ArticleDetailViewController.segueIdentifer {
            guard let articleDetailVC = segue.destination as? ArticleDetailViewController,
                  let indexPath = sender as? IndexPath,
                  let articles = articles
                else { return }
            articleDetailVC.article = articles[indexPath.row]
        }
    }
}

extension ArticleListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let articles = articles else { return 0 }
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let articles = articles,
        let articleCell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifer) as? ArticleTableViewCell
            else { return UITableViewCell() }
        let article = articles[indexPath.row]
        articleCell.prepCell(with: ArticleTableViewCell.CellData(title: article.title,
                                                                 imageURL: URL(string: article.thumbnail) ?? nil,
                                                                 height: article.thumbnailHeight ?? nil))
        return articleCell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let articles = articles else { return 0 }
        if let height = articles[indexPath.row].thumbnailHeight {
            return CGFloat(height) + 40
        } else {
            return 83
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ArticleDetailViewController.segueIdentifer, sender: indexPath)
    }
}

