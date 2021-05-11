//
//  MockInitialPresenter.swift
//  FlickrWalkTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import Foundation
@testable import FlickrWalk

class MockInitialPresenter: InitialPresenterProtocol {
    var actions: [Action] = []

    enum Action: Equatable {
        case attach
        case initialLoad
        case load
    }

    func attach(_ view: InitialViewProtocol) {
        actions.append(.attach)
    }

    func initialLoad() {
        actions.append(.initialLoad)
    }

    func load() {
        actions.append(.load)
    }
}
