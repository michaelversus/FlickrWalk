//
//  RegionMonitoringLocationManagerTests.swift
//  RegionMonitoringLocationManagerTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 06/05/2021.
//

import XCTest
import CoreLocation
@testable import LocationUtils

class RegionMonitoringLocationManagerTests: XCTestCase {

    var currentLoc: CLLocation?
    var currentAccuracy: CLAccuracyAuthorization?
    var currentError: Error?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_requestAlwaysAuthorization() {
        // Given
        let locationManager = CLLocationManagerMock(
            authorizationStatus: .authorizedAlways,
            accuracyAuthorization: .fullAccuracy,
            currentLocationResult: .success(CLLocation.apple)
        )
        let radius: Double = 100
        let sut = RegionMonitoringLocationManager(radius: radius, locationManager: locationManager)
        sut.didChangeAuthorization = { [weak self] accuracy, status in
            self?.currentAccuracy = accuracy
        }

        // When
        sut.requestAlwaysAuthorization()

        // Then
        XCTAssertEqual(locationManager.actions, [.requestAlwaysAuthorization])
        XCTAssertTrue(sut.isAuthorized())
        XCTAssertEqual(currentAccuracy, .fullAccuracy)
    }

    func test_start_success() {
        // Given
        let locationManager = CLLocationManagerMock(
            authorizationStatus: .authorizedAlways,
            accuracyAuthorization: .fullAccuracy,
            currentLocationResult: .success(CLLocation.apple),
            numberOfRegionExits: 2
        )
        let radius: Double = 100
        let sut = RegionMonitoringLocationManager(
            radius: radius,
            locationManager: locationManager
        )
        sut.didUpdateCurrentLocation = { [weak self] loc in
            self?.currentLoc = loc
        }

        // When
        sut.start()

        // Then
        let expectedLocationManagerActions: [CLLocationManagerMock.Action] = [
            .requestLocation,
            .startMonitoring(region: CLCircularRegion.appleRegion),
            .requestLocation,
            .stopMonitoring(region: CLCircularRegion.appleRegion),
            .startMonitoring(region: CLCircularRegion.appleRegion),
            .requestLocation,
            .stopMonitoring(region: CLCircularRegion.appleRegion),
            .startMonitoring(region: CLCircularRegion.appleRegion)
        ]
        XCTAssertEqual(locationManager.actions, expectedLocationManagerActions)
        XCTAssertEqual(currentLoc, .apple)
    }

    func test_start_failure() {
        // Given
        let locationManager = CLLocationManagerMock(
            authorizationStatus: .authorizedAlways,
            accuracyAuthorization: .fullAccuracy,
            currentLocationResult: .failure(UnknownError()),
            numberOfRegionExits: 2
        )
        let radius: Double = 100
        let sut = RegionMonitoringLocationManager(
            radius: radius,
            locationManager: locationManager
        )
        sut.didFailWithError = { [weak self] error in
            self?.currentError = error
        }

        // When
        sut.start()

        // Then
        let expectedLocationManagerActions: [CLLocationManagerMock.Action] = [
            .requestLocation
        ]
        XCTAssertEqual(locationManager.actions, expectedLocationManagerActions)
        XCTAssertTrue(currentError is UnknownError)
    }

    func test_stop_success() {
        // Given
        let locationManager = CLLocationManagerMock(
            authorizationStatus: .authorizedAlways,
            accuracyAuthorization: .fullAccuracy,
            currentLocationResult: .success(CLLocation.apple),
            numberOfRegionExits: 1
        )
        let radius: Double = 100
        let sut = RegionMonitoringLocationManager(
            radius: radius,
            locationManager: locationManager
        )

        // When
        sut.start()
        sut.stop()

        // Then
        let expectedLocationManagerActions: [CLLocationManagerMock.Action] = [
            .requestLocation,
            .startMonitoring(region: CLCircularRegion.appleRegion),
            .requestLocation,
            .stopMonitoring(region: CLCircularRegion.appleRegion),
            .startMonitoring(region: CLCircularRegion.appleRegion),
            .stopMonitoring(region: CLCircularRegion.appleRegion)
        ]
        XCTAssertEqual(locationManager.actions, expectedLocationManagerActions)
    }

    func test_stop_failure() {
        // Given
        let locationManager = CLLocationManagerMock(
            authorizationStatus: .authorizedAlways,
            accuracyAuthorization: .fullAccuracy,
            currentLocationResult: .failure(UnknownError()),
            numberOfRegionExits: 1
        )
        let radius: Double = 100
        let sut = RegionMonitoringLocationManager(
            radius: radius,
            locationManager: locationManager
        )

        // When
        sut.stop()

        // Then
        let expectedLocationManagerActions: [CLLocationManagerMock.Action] = [
        ]
        XCTAssertEqual(locationManager.actions, expectedLocationManagerActions)
    }
}

extension CLLocation {
    static let apple: CLLocation = CLLocation(latitude: 37.3318, longitude: -122.0312)
}

extension CLCircularRegion {
    static let appleRegion: CLCircularRegion = CLCircularRegion(center: CLLocation.apple.coordinate, radius: 100, identifier: "currentRegion")
}

struct UnknownError: Error {}
