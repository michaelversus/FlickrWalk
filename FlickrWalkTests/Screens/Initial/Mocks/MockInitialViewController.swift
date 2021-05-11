//
//  MockInitialViewController.swift
//  FlickrWalkTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import Foundation
@testable import FlickrWalk

class MockInitialViewController: InitialViewProtocol {
    var actions: [Action] = []

    enum Action: Equatable {
        case goToPhotos
        case setupTitle(text: String)
        case setupButtonTitle(text: String)
        case presentAlert(title: String, message: String)
    }

    func goToPhotos() {
        actions.append(.goToPhotos)
    }

    func setupTitle(text: String) {
        actions.append(.setupTitle(text: text))
    }

    func setupButtonTitle(text: String) {
        actions.append(.setupButtonTitle(text: text))
    }

    func presentAlert(with title: String, message: String) {
        actions.append(.presentAlert(title: title, message: message))
    }
}
