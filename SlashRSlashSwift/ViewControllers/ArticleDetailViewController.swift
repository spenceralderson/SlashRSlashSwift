//
//  ArticleDetailViewController.swift
//  SlashRSlashSwift
//
//  Created by Spencer Alderson on 2019-08-09.
//  Copyright © 2019 Spencer Alderson. All rights reserved.
//

import UIKit

final class ArticleDetailViewController: UIViewController {
    
    @IBOutlet private weak var articleImageView: UIImageView!
    @IBOutlet private weak var articleBodyLabel: UILabel!
    
    static var segueIdentifer: String = "articleDetailSegue"
    
    var article: Article? 

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        prepView()
    }
    
    private func prepView() {
        guard let article = article else { return }
        self.title = article.title
        self.articleBodyLabel.text = article.selftext
        guard article.thumbnail.isValidURL,
            let imageURL = URL(string: article.thumbnail) else {
            articleImageView.isHidden = true
            return
        }
        articleImageView.kf.setImage(with: imageURL)
    }
}
