//
//  PhotosViewControllerTests.swift
//  FlickrWalkTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import XCTest
@testable import FlickrWalk

class PhotosViewControllerTests: XCTestCase {

    func test_viewDidLoad() {
        // Given
        let presenter = MockPhotosPresenter()
        let sut = PhotosViewController(presenter: presenter)

        // When
        _ = sut.view // to call viewDidLoad

        // Then
        let expectedPresenterActions: [MockPhotosPresenter.Action] = [
            .attach,
            .initialLoad
        ]
        XCTAssertEqual(presenter.actions, expectedPresenterActions)
    }

    func test_handleStopButtonTapped() {
        // Given
        let presenter = MockPhotosPresenter()
        let sut = PhotosViewController(presenter: presenter)

        // When
        sut.handleStopButtonTapped()

        // Then
        let expectedPresenterActions: [MockPhotosPresenter.Action] = [
            .stopUpdates
        ]
        XCTAssertEqual(presenter.actions, expectedPresenterActions)
    }

}
