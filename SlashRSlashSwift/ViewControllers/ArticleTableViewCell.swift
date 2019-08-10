//
//  ArticleTableViewCell.swift
//  SlashRSlashSwift
//
//  Created by Spencer Alderson on 2019-08-08.
//  Copyright © 2019 Spencer Alderson. All rights reserved.
//

import UIKit
import Kingfisher

final class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var articleTitleLabel: UILabel!
    @IBOutlet private weak var articleImageView: UIImageView!
    @IBOutlet private weak var articleIgameViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        self.articleImageView.kf.indicatorType = .activity
    }
    
    static var identifer: String = "articleTableViewCell"
    
    private func constrainImageView(for height: CGFloat) {
        articleIgameViewHeightConstraint.constant = height
    }
    
    func prepCell(with data: CellData) {
        self.articleTitleLabel.text = data.title
        if let imageURL = data.imageURL, imageURL.absoluteString != "self" {
            guard let imageViewHeight = data.height else { return }
            self.articleImageView.isHidden = false
            constrainImageView(for: CGFloat(imageViewHeight))
            layoutIfNeeded()
            self.articleImageView.kf.setImage(with: imageURL)
        } else {
            self.articleImageView.isHidden = true
            self.constrainImageView(for: 0.0)
            layoutIfNeeded()
        }
    }
    
    override func prepareForReuse() {
        self.articleImageView.kf.cancelDownloadTask()
        self.articleImageView.image = nil
        self.constrainImageView(for: 0.0)
    }
    
    struct CellData {
        let title: String
        let imageURL: URL?
        let height: Int?
    }
}
