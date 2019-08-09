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
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Swift News"
        self.tableView.rowHeight = UITableView.automaticDimension
        fetchArticles()
    }
    
    private func fetchArticles() {
        self.networkService.fetchArticles { result in
            switch result {
            case .success(let articles):
                DispatchQueue.main.async {
                    self.articles = articles
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
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
    
}

