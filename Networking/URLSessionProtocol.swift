//
//  URLSessionProtocol.swift
//  Networking
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import Foundation

public protocol URLSessionProtocol {
    @discardableResult
    func load<A>(_ resource: Resource<A>, onComplete: @escaping (Result<A, Error>) -> ()) -> URLSessionDataTask
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

extension URLSessionProtocol {
    @discardableResult
    /// Loads a resource by creating (and directly resuming) a data task.
    ///
    /// - Parameters:
    ///   - resource: The resource.
    ///   - onComplete: The completion handler.
    /// - Returns: The data task.
    public func load<A>(_ resource: Resource<A>, onComplete: @escaping (Result<A, Error>) -> ()) -> URLSessionDataTask {
        let request = resource.request
        let task = dataTask(with: request, completionHandler: { data, resp, err in
            if let err = err {
                onComplete(.failure(err))
                return
            }

            guard let httpResponse = resp as? HTTPURLResponse else {
                onComplete(.failure(UnknownError()))
                return
            }

            guard resource.expectedStatusCode(httpResponse.statusCode) else {
                onComplete(.failure(WrongStatusCodeError(statusCode: httpResponse.statusCode, response: httpResponse, responseBody: data)))
                return
            }

            onComplete(resource.parse(data,resp))
        })
        task.resume()
        return task
    }
}
