//
//  MockPhotosViewController.swift
//  FlickrWalkTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import Foundation
import CommonUtils
@testable import FlickrWalk

final class MockPhotosViewController: PhotosViewProtocol {
    var actions: [Action] = []

    enum Action: Equatable {
        case setupTitle(text: String)
        case setupStopButton(title: String)
        case updateListView(cellItem: CellItem)
    }

    func setupTitle(text: String) {
        actions.append(.setupTitle(text: text))
    }

    func setupStopButton(title: String) {
        actions.append(.setupStopButton(title: title))
    }

    func updateListView(cellItem: CellItem) {
        actions.append(.updateListView(cellItem: cellItem))
    }
}
