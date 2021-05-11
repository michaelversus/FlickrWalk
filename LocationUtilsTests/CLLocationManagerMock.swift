//
//  CLLocationManagerMock.swift
//  LocationUtilsTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 10/05/2021.
//

import LocationUtils
import CoreLocation

final class CLLocationManagerMock: CLLocationManagerProtocol {
    var allowsBackgroundLocationUpdates: Bool = false
    var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyReduced
    var activityType: CLActivityType = .automotiveNavigation
    weak var delegate: CLLocationManagerDelegate?
    var authorizationStatus: CLAuthorizationStatus
    var accuracyAuthorization: CLAccuracyAuthorization
    var currentLocationResult: Result<CLLocation, Error>
    var actions: [Action] = []
    let numberOfRegionExits: Int
    var exitsCount: Int = 0

    enum Action: Equatable {
        case stopMonitoring(region: CLRegion)
        case startMonitoring(region: CLRegion)
        case requestLocation
        case requestAlwaysAuthorization
    }

    init(
        authorizationStatus: CLAuthorizationStatus,
        accuracyAuthorization: CLAccuracyAuthorization,
        currentLocationResult: Result<CLLocation, Error>,
        numberOfRegionExits: Int = 1
    ) {
        self.accuracyAuthorization = accuracyAuthorization
        self.authorizationStatus = authorizationStatus
        self.currentLocationResult = currentLocationResult
        self.numberOfRegionExits = numberOfRegionExits
    }


    func stopMonitoring(for region: CLRegion) {
        actions.append(.stopMonitoring(region: region))
    }

    func startMonitoring(for region: CLRegion) {
        actions.append(.startMonitoring(region: region))
        if exitsCount < numberOfRegionExits {
            exitsCount += 1
            delegate?.locationManager?(CLLocationManager(), didExitRegion: region)
        }
    }

    func requestLocation() {
        actions.append(.requestLocation)
        switch currentLocationResult {
        case .success(let location):
            delegate?.locationManager?(CLLocationManager(), didUpdateLocations: [location])
        case .failure(let error):
            delegate?.locationManager?(CLLocationManager(), didFailWithError: error)
        }
    }

    func requestAlwaysAuthorization() {
        actions.append(.requestAlwaysAuthorization)
        let manager = CLLocationManager()
        delegate?.locationManagerDidChangeAuthorization?(manager)
    }

    
}
