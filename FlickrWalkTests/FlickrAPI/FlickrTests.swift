//
//  FlickrTests.swift
//  FlickrWalkTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import XCTest
@testable import FlickrWalk

class FlickrTests: XCTestCase {

    let jsonString: String = """
    {
        "photos": {
            "page": 1,
            "pages": 2,
            "perpage": 1,
            "total": "total",
            "photo": [
                {
                    "id": "1",
                    "owner": "owner",
                    "secret": "secret",
                    "server": "server",
                    "farm": 3,
                    "title": "title"
                }
            ]
        },
        "stat": "3"
    }
    """

    func test_decoding() throws {
        // Given, When
        let sut = try jsonString.parseLiteral(type: Flickr.self)

        // Then
        XCTAssertEqual(sut.stat, "3")
        XCTAssertEqual(sut.photos.page, 1)
        XCTAssertEqual(sut.photos.pages, 2)
        XCTAssertEqual(sut.photos.perpage, 1)
        XCTAssertEqual(sut.photos.total, "total")
        XCTAssertEqual(sut.photos.photo.first?.id, "1")
        XCTAssertEqual(sut.photos.photo.first?.owner, "owner")
        XCTAssertEqual(sut.photos.photo.first?.secret, "secret")
        XCTAssertEqual(sut.photos.photo.first?.server, "server")
        XCTAssertEqual(sut.photos.photo.first?.farm, 3)
        XCTAssertEqual(sut.photos.photo.first?.title, "title")
        XCTAssertEqual(sut.photos.photo.first?.urlString, "https://farm3.staticflickr.com/server/1_secret.jpg")
    }
}

extension String {
    func parseLiteral<U>(type: U.Type) throws -> U where U: Decodable {
        guard let data = self.data(using: .utf8) else { throw UnknownDecodingError() }
        return try JSONDecoder().decode(U.self, from: data)
    }
}

struct UnknownDecodingError: Error {}
