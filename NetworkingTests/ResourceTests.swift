//
//  ResourceTests.swift
//  NetworkingTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import XCTest
import Networking

class ResourceTests: XCTestCase {

    func test_generic_init() throws {
        // Given
        let method: Resource<String>.Method = .get
        let url = try XCTUnwrap(URL(string: "https://www.apple.com"))
        let accept: ContentType = .json
        let contentType: ContentType = .json
        let headers = ["headerKey": "headerValue"]
        let query = ["key": "value"]

        // When
        let sut = Resource<String>(
            method,
            url: url,
            accept: accept,
            contentType: contentType,
            headers: headers,
            query: query,
            parse: { _, _ in return .success("") }
        )

        // Then
        XCTAssertEqual(sut.request.url?.absoluteString, "https://www.apple.com?key=value")
        XCTAssertEqual(sut.request.httpMethod, "GET")
        XCTAssertNil(sut.request.httpBody)
        XCTAssertEqual(sut.request.allHTTPHeaderFields, ["headerKey": "headerValue", "Accept": "application/json", "Content-Type": "application/json"])
        XCTAssertEqual(sut.request.timeoutInterval, 10)
    }

    func test_generic_init_urlRequest() throws {
        // Given
        let url = try XCTUnwrap(URL(string: "https://www.apple.com"))
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)

        // When
        let sut = Resource<String>(
            request: request,
            parse: { _, _ in return .success("") }
        )

        // Then
        XCTAssertEqual(sut.request.url?.absoluteString, "https://www.apple.com")
        XCTAssertEqual(sut.request.httpMethod, "GET")
        XCTAssertNil(sut.request.httpBody)
        XCTAssertNil(sut.request.allHTTPHeaderFields)
        XCTAssertEqual(sut.request.timeoutInterval, 10)
    }

    func test_description() throws {
        // Given
        let url = try XCTUnwrap(URL(string: "https://www.apple.com"))
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        let sut = Resource<String>(
            request: request,
            parse: { _, _ in return .success("") }
        )

        // When
        let description = sut.description

        // Then
        XCTAssertEqual(description, "GET https://www.apple.com ")
    }

    func test_data_init() throws {
        // Given
        let method: Resource<Data>.Method = .get
        let url = try XCTUnwrap(URL(string: "https://www.apple.com"))
        let accept: ContentType = .json
        let contentType: ContentType = .json
        let headers = ["headerKey": "headerValue"]
        let query = ["key": "value"]

        // When
        let sut = Resource<Data>(
            method,
            url: url,
            accept: accept,
            contentType: contentType,
            headers: headers,
            query: query
        )

        // Then
        XCTAssertEqual(sut.request.url?.absoluteString, "https://www.apple.com?key=value")
        XCTAssertEqual(sut.request.httpMethod, "GET")
        XCTAssertNil(sut.request.httpBody)
        XCTAssertEqual(sut.request.allHTTPHeaderFields, ["headerKey": "headerValue", "Accept": "application/json", "Content-Type": "application/json"])
        XCTAssertEqual(sut.request.timeoutInterval, 10)
    }

    func test_void_init() throws {
        // Given
        let method: Resource<()>.Method = .get
        let url = try XCTUnwrap(URL(string: "https://www.apple.com"))
        let accept: ContentType = .json
        let contentType: ContentType = .json
        let headers = ["headerKey": "headerValue"]
        let query = ["key": "value"]

        // When
        let sut = Resource<()>(
            method,
            url: url,
            accept: accept,
            contentType: contentType,
            headers: headers,
            query: query
        )

        // Then
        XCTAssertEqual(sut.request.url?.absoluteString, "https://www.apple.com?key=value")
        XCTAssertEqual(sut.request.httpMethod, "GET")
        XCTAssertNil(sut.request.httpBody)
        XCTAssertEqual(sut.request.allHTTPHeaderFields, ["headerKey": "headerValue", "Accept": "application/json", "Content-Type": "application/json"])
        XCTAssertEqual(sut.request.timeoutInterval, 10)
    }

    func test_encodable_init() throws {
        // Given
        let url = try XCTUnwrap(URL(string: "https://www.apple.com"))
        let headers = ["headerKey": "headerValue"]
        let query = ["key": "value"]
        let body = TestEncodable(test: "test")

        // When
        let sut = Resource(
            json: .get,
            url: url,
            body: body,
            headers: headers,
            query: query
        )

        // Then
        let expectedBody = try XCTUnwrap(JSONEncoder().encode(body))
        XCTAssertEqual(sut.request.url?.absoluteString, "https://www.apple.com?key=value")
        XCTAssertEqual(sut.request.httpMethod, "GET")
        XCTAssertEqual(sut.request.httpBody, expectedBody)
        XCTAssertEqual(sut.request.allHTTPHeaderFields, ["headerKey": "headerValue", "Accept": "application/json", "Content-Type": "application/json"])
        XCTAssertEqual(sut.request.timeoutInterval, 10)
    }
}

struct TestEncodable: Encodable, Equatable {
    let test: String
}

struct TestDecodable: Decodable, Equatable {
    let result: String
}
