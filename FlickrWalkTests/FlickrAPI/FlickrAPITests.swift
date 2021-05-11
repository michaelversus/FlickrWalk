//
//  FlickrAPITests.swift
//  FlickrWalkTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import XCTest
import CoreLocation
@testable import FlickrWalk

class FlickrAPITests: XCTestCase {

    func test_baseURL() throws {
        // Given
        let location: CLLocation = CLLocation.apple
        let sut = FlickrAPI(location: location)

        // When
        let url = sut.baseURL()

        // Then
        let expectedURL = try XCTUnwrap(URL(string: "https://api.flickr.com/services/rest"))
        XCTAssertEqual(url, expectedURL)
    }

    func test_photoSearchQuery() {
        // Given
        let location: CLLocation = CLLocation.apple
        let sut = FlickrAPI(location: location)

        // When
        let query: [String: String] = sut.photoSearchQuery()

        // Then
        let expectedQuery: [String: String] = [
            "format": "json",
            "radius": "0.1",
            "lat": "37.3318",
            "lon": "-122.0312",
            "api_key": "d23b67424737910ba8f25f92aec40438",
            "method": "flickr.photos.search",
            "nojsoncallback": "1",
            "per_page": "1"
        ]
        XCTAssertEqual(query, expectedQuery)
    }
}
