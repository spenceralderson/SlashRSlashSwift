//
//  ArticleListViewModel.swift
//  SlashRSlashSwift
//
//  Created by Spencer Alderson on 2019-08-11.
//  Copyright © 2019 Spencer Alderson. All rights reserved.
//

import Foundation


final class ArticleListViewModel: NetworkServiceInjectable {
    
    typealias didChange = (([Article]?, Error?) -> ())
    
    var didChange: didChange?
    
    var articles: [Article]?
    
    init() {
        self.fetchArticles()
    }
    
    func fetchArticles() {
        self.networkService.fetchArticles { result in
            switch result {
            case .success(let articles):
                self.articles = articles
                self.didChange?(articles, nil)
            case .failure(let error):
                self.didChange?(nil, error)
            }
        }
    }
}
