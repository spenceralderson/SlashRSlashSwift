//
//  SlashRSlashSwiftTests.swift
//  SlashRSlashSwiftTests
//
//  Created by Spencer Alderson on 2019-08-08.
//  Copyright © 2019 Spencer Alderson. All rights reserved.
//

import XCTest
@testable import SlashRSlashSwift

class SlashRSlashSwiftTests: XCTestCase {

    func testModels() {
        let article = Article(title: "Test", created: Date(), articleBody: "BODY", thumbnail: "self", thumbnailHeight: 60)
        let articleResponse = ArticleResponse(kind: "t3", data: article)
        let dataResponse = DataResponse(children: [articleResponse])
        let response = Response(kind: "Listing", data: dataResponse)
        
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

}
