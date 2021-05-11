//
//  File.swift
//  FlickrWalkTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import Foundation
import Networking
@testable import FlickrWalk

class MockURLSession: URLSessionProtocol {

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(nil, nil, nil)
        let mockURL = URL(string: "https://")!
        return URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: mockURL))
    }

    var results: [Result<Any, Error>]

    init(results: [Result<Any, Error>]) {
        self.results = results
    }

    func load<A>(_ resource: Resource<A>, onComplete: @escaping (Result<A, Error>) -> ()) -> URLSessionDataTask {
        do {
            let anyResult = try results.first?.get()
            guard let castedResult = anyResult as? A else { throw MockURLSessionError() }
            results.removeFirst()
            onComplete(.success(castedResult as A))
        } catch {
            results.removeFirst()
            onComplete(.failure(error))
        }
        let mockURL = URL(string: "https://")!
        return URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: mockURL))
    }
}

struct MockURLSessionError: Error {}
