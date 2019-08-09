//
//  Article.swift
//  SlashRSlashSwift
//
//  Created by Spencer Alderson on 2019-08-08.
//  Copyright © 2019 Spencer Alderson. All rights reserved.
//

import Foundation

struct Response: Decodable {
    let kind: String
    let data: DataResponse
}

struct DataResponse: Decodable {
    let children: [ArticleResponse]
}

struct ArticleResponse: Decodable {
    let kind: String
    let data: Article
}

struct Article: Decodable {
    let title: String
    let clicked: Bool
    let hidden: Bool
    let created: Date
    let author: String
    let selftext: String
    let thumbnail: String
}
