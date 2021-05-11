//
//  InitialViewControllerTests.swift
//  FlickrWalkTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import XCTest
@testable import FlickrWalk

class InitialViewControllerTests: XCTestCase {

    func test_viewDidLoad() {
        // Given
        let presenter = MockInitialPresenter()
        let sut = InitialViewController(presenter: presenter)

        // When
        _ = sut.view // to call viewDidLoad()

        //Then
        let expectedPresenterActions: [MockInitialPresenter.Action] = [
            .attach,
            .initialLoad
        ]
        XCTAssertEqual(presenter.actions, expectedPresenterActions)
    }

    func test_handleStartButton() {
        // Given
        let presenter = MockInitialPresenter()
        let sut = InitialViewController(presenter: presenter)

        // When
        sut.handleStartButton()

        //Then
        let expectedPresenterActions: [MockInitialPresenter.Action] = [
            .load
        ]
        XCTAssertEqual(presenter.actions, expectedPresenterActions)
    }
}
