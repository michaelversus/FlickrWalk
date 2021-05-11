//
//  MockPhotosPresenter.swift
//  FlickrWalkTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import Foundation
@testable import FlickrWalk

final class MockPhotosPresenter: PhotosPresenterProtocol {
    var actions: [Action] = []

    enum Action: Equatable {
        case attach
        case initialLoad
        case stopUpdates
    }

    func attach(_ view: PhotosViewProtocol) {
        actions.append(.attach)
    }

    func initialLoad() {
        actions.append(.initialLoad)
    }

    func stopUpdates() {
        actions.append(.stopUpdates)
    }
}

