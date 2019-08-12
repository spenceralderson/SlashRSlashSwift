//
//  Article.swift
//  SlashRSlashSwift
//
//  Created by Spencer Alderson on 2019-08-08.
//  Copyright © 2019 Spencer Alderson. All rights reserved.
//

import Foundation

struct Response: Codable, Equatable {
    let data: DataResponse
}

struct DataResponse: Codable, Equatable {
    let children: [ArticleResponse]
}

struct ArticleResponse: Codable, Equatable {
    let article: Article
    
    enum CodingKeys: String, CodingKey {
        case article = "data"
    }
}

struct Article: Codable, Equatable {
    let title: String
    let created: Date
    let articleBody: String
    let thumbnail: String
    let thumbnailHeight: Int?
    
    enum CodingKeys: String, CodingKey {
        case title
        case created
        case articleBody = "selftext"
        case thumbnail
        case thumbnailHeight
    }
}
