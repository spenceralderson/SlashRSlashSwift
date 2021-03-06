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
        self.navigationItem.largeTitleDisplayMode = .never
        self.prepView()
    }
    
    private func prepView() {
        guard let article = article else { return }
        self.title = article.title
        self.articleBodyLabel.text = article.articleBody
        guard article.thumbnail.isValidURL,
            let imageURL = URL(string: article.thumbnail) else {
            self.articleImageView.isHidden = true
            return
        }
        self.articleImageView.kf.setImage(with: imageURL)
    }
}
