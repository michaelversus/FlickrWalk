//
//  URLSessionTests.swift
//  NetworkingTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import XCTest
import Networking

struct DataTaskError: Error {}

struct MockURLSession: URLSessionProtocol {
    let data: Data?
    let urlResponse: URLResponse?
    let error: Error?

    public init(data: Data?, urlResponse: URLResponse?, error: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self.error = error
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(data, urlResponse, error)
        let mockURL = URL(string: "https://")!
        return URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: mockURL))
    }
}


class URLSessionTests: XCTestCase {

    var error: Error?
    var resultString: String?

    func test_load_error() throws {
        // Given
        let url = try XCTUnwrap(URL(string: "https://www.apple.com"))
        let request = URLRequest(url: url)
        let onComplete: (Result<String, Error>) -> () = { [weak self] result in
            switch result {
            case .success:
                break
            case .failure(let error):
                self?.error = error
            }
        }
        let resource = Resource(request: request, parse: { _, _ in return .success("") })
        let sut = MockURLSession(data: nil, urlResponse: nil, error: DataTaskError())
        // When
        sut.load(resource, onComplete: onComplete)

        // Then
        XCTAssertTrue(error is DataTaskError)
    }

    func test_load_unknown_error() throws {
        // Given
        let url = try XCTUnwrap(URL(string: "https://www.apple.com"))
        let request = URLRequest(url: url)
        let onComplete: (Result<String, Error>) -> () = { [weak self] result in
            switch result {
            case .success:
                break
            case .failure(let error):
                self?.error = error
            }
        }
        let resource = Resource(request: request, parse: { _, _ in return .success("") })
        let sut = MockURLSession(data: nil, urlResponse: nil, error: nil)
        // When
        sut.load(resource, onComplete: onComplete)

        // Then
        XCTAssertTrue(error is UnknownError)
    }

    func test_load_wrong_status_code_error() throws {
        // Given
        let url = try XCTUnwrap(URL(string: "https://www.apple.com"))
        let request = URLRequest(url: url)
        let onComplete: (Result<String, Error>) -> () = { [weak self] result in
            switch result {
            case .success:
                break
            case .failure(let error):
                self?.error = error
            }
        }
        let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)
        let resource = Resource(request: request, parse: { _, _ in return .success("") })
        let sut = MockURLSession(data: nil, urlResponse: response, error: nil)
        // When
        sut.load(resource, onComplete: onComplete)

        // Then
        XCTAssertTrue(error is WrongStatusCodeError)
    }

    func test_load_success() throws {
        // Given
        let url = try XCTUnwrap(URL(string: "https://www.apple.com"))
        let request = URLRequest(url: url)
        let onComplete: (Result<String, Error>) -> () = { [weak self] result in
            switch result {
            case .success(let string):
                self?.resultString = string
            case .failure(let error):
                self?.error = error
            }
        }
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let resource = Resource(request: request, parse: { _, _ in return .success("resultsString") })
        let sut = MockURLSession(data: nil, urlResponse: response, error: nil)
        // When
        sut.load(resource, onComplete: onComplete)

        // Then
        XCTAssertEqual(resultString, "resultsString")
    }

}
