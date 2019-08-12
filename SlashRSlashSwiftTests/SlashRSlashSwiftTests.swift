//
//  SlashRSlashSwiftTests.swift
//  SlashRSlashSwiftTests
//
//  Created by Spencer Alderson on 2019-08-08.
//  Copyright © 2019 Spencer Alderson. All rights reserved.
//

import XCTest
@testable import SlashRSlashSwift

class SlashRSlashSwiftTests: XCTestCase, NetworkServiceInjectable {

    func testModels() {
        let article = Article(title: "Test", created: Date(), articleBody: "BODY", thumbnail: "self", thumbnailHeight: 60)
        let articleResponse = ArticleResponse(article: article)
        let dataResponse = DataResponse(children: [articleResponse])
        let response = Response(data: dataResponse)
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        do {
            let data = try encoder.encode(response.self)
            let object = try decoder.decode(Response.self, from: data)
            XCTAssertEqual(response, object)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testFetchArticles() {
        self.networkService.fetchArticles { result in
            switch result {
            case .success(let articles):
                XCTAssert(articles.count > 0, "Sucessful response but no articles came back")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
}
