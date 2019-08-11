//
//  Article.swift
//  SlashRSlashSwift
//
//  Created by Spencer Alderson on 2019-08-08.
//  Copyright © 2019 Spencer Alderson. All rights reserved.
//

import Foundation

struct Response: Codable, Equatable {
    let kind: String
    let data: DataResponse
}

struct DataResponse: Codable, Equatable {
    let children: [ArticleResponse]
}

struct ArticleResponse: Codable, Equatable {
    let kind: String
    let data: Article
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let title: String = try container.decode(String.self, forKey: .title)
        let created: Date = try container.decode(Date.self, forKey: .created)
        let articleBody: String = try container.decode(String.self, forKey: .articleBody)
        let thumbnail: String = try container.decode(String.self, forKey: .thumbnail)
        let thumbnailHeight: Int? = try container.decodeIfPresent(Int.self, forKey: .thumbnailHeight)
        
        self.init(title: title, created: created, articleBody: articleBody, thumbnail: thumbnail, thumbnailHeight: thumbnailHeight)
    }
    
    init(title: String, created: Date, articleBody: String, thumbnail: String, thumbnailHeight: Int?) {
        self.title = title
        self.created = created
        self.articleBody = articleBody
        self.thumbnail = thumbnail
        self.thumbnailHeight = thumbnailHeight
    }
}
