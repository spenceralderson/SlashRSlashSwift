//
//  ArticleTableViewCell.swift
//  SlashRSlashSwift
//
//  Created by Spencer Alderson on 2019-08-08.
//  Copyright © 2019 Spencer Alderson. All rights reserved.
//

import UIKit

final class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var articleTitleLabel: UILabel!
    @IBOutlet private weak var articleImageView: UIImageView!
    
    static var identifer: String = "articleTableViewCell"
    
    var cellData: CellData? {
        didSet {
            guard let cellData = cellData else { return }
            self.articleTitleLabel.text = cellData.title
        }
    }
    
    struct CellData {
        let title: String
        let image: String
    }
}
