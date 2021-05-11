//
//  MockMainQueue.swift
//  FlickrWalkTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import Foundation
@testable import FlickrWalk

struct MockMainQueue: DispatchQueueProtocol {
    func executeAsync(_ work: @escaping () -> Void) {
            work()
    }
}
