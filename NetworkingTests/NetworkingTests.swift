//
//  NetworkingTests.swift
//  NetworkingTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 06/05/2021.
//

import XCTest
@testable import Networking

class NetworkingTests: XCTestCase {

    func test_expected200to300_success() {
        // Given
        let statusCode = 200

        // When
        let sut = expected200to300(statusCode)

        // Then
        XCTAssertTrue(sut)
    }

    func test_expected200to300_failure() {
        // Given
        let statusCode = 400

        // When
        let sut = expected200to300(statusCode)

        // Then
        XCTAssertFalse(sut)
    }
}
