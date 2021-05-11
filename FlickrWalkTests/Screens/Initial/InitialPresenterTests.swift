//
//  InitialPresenterTests.swift
//  FlickrWalkTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import XCTest
@testable import FlickrWalk

class InitialPresenterTests: XCTestCase {

    func test_initialLoad() {
        // Given
        let locationManager = MockLocationManager()
        let sut = InitialPresenter(locationManager: locationManager)
        let view = MockInitialViewController()
        sut.attach(view)

        // When
        sut.initialLoad()

        // Then
        let expectedViewActions: [MockInitialViewController.Action] = [
            .setupTitle(text: "Flickr Walk"),
            .setupButtonTitle(text: "START")
        ]
        XCTAssertEqual(view.actions, expectedViewActions)
    }

    func test_load_givenUnauthorizedLocationManager() {
        // Given
        let locationManager = MockLocationManager(isAuthorized: false)
        let sut = InitialPresenter(locationManager: locationManager)
        let view = MockInitialViewController()
        sut.attach(view)

        // When
        sut.load()

        // Then
        let expectedLocationActions: [MockLocationManager.Action] = [
            .isAuthorized,
            .requestAlwaysAuthorization
        ]
        XCTAssertEqual(locationManager.actions, expectedLocationActions)
    }

    func test_load_givenAuthorizedLocationManager() {
        // Given
        let locationManager = MockLocationManager(isAuthorized: true)
        let sut = InitialPresenter(
            locationManager: locationManager,
            mainQueue: MockMainQueue()
        )
        let view = MockInitialViewController()
        sut.attach(view)

        // When
        sut.load()

        // Then
        let expectedLocationActions: [MockLocationManager.Action] = [
            .isAuthorized
        ]
        let expectedViewActions: [MockInitialViewController.Action] = [
            .goToPhotos
        ]
        XCTAssertEqual(locationManager.actions, expectedLocationActions)
        XCTAssertEqual(view.actions, expectedViewActions)
    }

    func test_didChangeAuthorization_givenInvalidAuthorizationStatus() {
        // Given
        let locationManager = MockLocationManager(isAuthorized: true)
        let sut = InitialPresenter(
            locationManager: locationManager,
            mainQueue: MockMainQueue()
        )
        let view = MockInitialViewController()
        sut.attach(view)

        // When
        sut.didChangeAuthorization(accuracy: .fullAccuracy, status: .denied)

        // Then
        let expectedViewActions: [MockInitialViewController.Action] = [
            .presentAlert(title: "Caution", message: "The app needs authorization for your location to work as expected")
        ]
        XCTAssertEqual(view.actions, expectedViewActions)
    }

    func test_didChangeAuthorization_givenInvalidAccuracy() {
        // Given
        let locationManager = MockLocationManager(isAuthorized: true)
        let sut = InitialPresenter(
            locationManager: locationManager,
            mainQueue: MockMainQueue()
        )
        let view = MockInitialViewController()
        sut.attach(view)

        // When
        sut.didChangeAuthorization(accuracy: .reducedAccuracy, status: .authorizedAlways)

        // Then
        let expectedViewActions: [MockInitialViewController.Action] = [
            .presentAlert(title: "Caution", message: "The app needs full accuracy for your location to work as expected")
        ]
        XCTAssertEqual(view.actions, expectedViewActions)
    }

    func test_didChangeAuthorization_success() {
        // Given
        let locationManager = MockLocationManager(isAuthorized: true)
        let sut = InitialPresenter(
            locationManager: locationManager,
            mainQueue: MockMainQueue()
        )
        let view = MockInitialViewController()
        sut.attach(view)

        // When
        sut.didChangeAuthorization(accuracy: .fullAccuracy, status: .authorizedAlways)

        // Then
        let expectedViewActions: [MockInitialViewController.Action] = [
            .goToPhotos
        ]
        XCTAssertEqual(view.actions, expectedViewActions)
    }

    func test_didFailWithError() {
        // Given
        let locationManager = MockLocationManager(isAuthorized: true)
        let sut = InitialPresenter(
            locationManager: locationManager,
            mainQueue: MockMainQueue()
        )
        let view = MockInitialViewController()
        sut.attach(view)

        // When
        sut.didFailWithError(error: UnknownDecodingError())

        // Then
        let expectedViewActions: [MockInitialViewController.Action] = [
            .presentAlert(title: "Caution", message: "Something went wrong")
        ]
        XCTAssertEqual(view.actions, expectedViewActions)
    }
}
