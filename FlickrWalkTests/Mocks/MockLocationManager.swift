//
//  MockLocationManager.swift
//  FlickrWalkTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import Foundation
import LocationUtils
import CoreLocation
@testable import FlickrWalk

final class MockLocationManager: LocationManagerProtocol {

    var didChangeAuthorization: ((CLAccuracyAuthorization, CLAuthorizationStatus) -> Void)?
    var didUpdateCurrentLocation: ((CLLocation) -> Void)?
    var didFailWithError: ((Error) -> Void)?
    let accuracy: CLAccuracyAuthorization
    let authorizationStatus: CLAuthorizationStatus
    let location: CLLocation
    let _isAuthorized: Bool
    var actions: [Action] = []

    enum Action: Equatable {
        case locationManagerDidChangeAuthorization(CLAccuracyAuthorization, CLAuthorizationStatus)
        case didUpdateLocation(CLLocation)
        case start
        case stop
        case requestAlwaysAuthorization
        case isAuthorized
    }

    init(
        accuracy: CLAccuracyAuthorization = .fullAccuracy,
        authorizationStatus: CLAuthorizationStatus = .authorizedAlways,
        location: CLLocation = CLLocation.apple,
        isAuthorized: Bool = true,
        didChangeAuthorization: ((CLAccuracyAuthorization, CLAuthorizationStatus) -> Void)? = nil,
        didUpdateCurrentLocation: ((CLLocation) -> Void)? = nil,
        didFailWithError: ((Error) -> Void)? = nil
    ) {
        self.accuracy = accuracy
        self.authorizationStatus = authorizationStatus
        self.location = location
        self._isAuthorized = isAuthorized
        self.didChangeAuthorization = didChangeAuthorization
        self.didUpdateCurrentLocation = didUpdateCurrentLocation
        self.didFailWithError = didFailWithError
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        actions.append(.locationManagerDidChangeAuthorization(accuracy, authorizationStatus))
        didChangeAuthorization?(accuracy, authorizationStatus)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        actions.append(.didUpdateLocation(location))
        didUpdateCurrentLocation?(location)
    }

    func start() {
        actions.append(.start)
    }

    func stop() {
        actions.append(.stop)
    }

    func requestAlwaysAuthorization() {
        actions.append(.requestAlwaysAuthorization)
    }

    func isAuthorized() -> Bool {
        actions.append(.isAuthorized)
        return _isAuthorized
    }
}

extension CLLocation {
    static let apple: CLLocation = CLLocation(latitude: 37.3318, longitude: -122.0312)
}

extension CLCircularRegion {
    static let appleRegion: CLCircularRegion = CLCircularRegion(center: CLLocation.apple.coordinate, radius: 100, identifier: "currentRegion")
}
