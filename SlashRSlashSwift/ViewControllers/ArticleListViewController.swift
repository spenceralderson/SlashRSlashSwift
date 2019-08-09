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
        self.tableView.estimatedRowHeight = 254.0
        fetchArticles()
    }
    
    private func fetchArticles() {
        self.networkService.fetchArticles { result in
            switch result {
            case .success(let articles):
                self.articles = articles
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ArticleListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let articles = articles else { return 0 }
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let articles = articles,
        let articleCell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifer) as? ArticleTableViewCell
            else { return UITableViewCell() }
        articleCell.cellData = ArticleTableViewCell.CellData(title: articles[indexPath.row].title,
                                                             image: articles[indexPath.row].thumbnail)
        articleCell.accessoryType = .disclosureIndicator
        return articleCell
    }
    
}

