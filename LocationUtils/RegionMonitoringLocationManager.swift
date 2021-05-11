//
//  RegionMonitoringLocationManager.swift
//  LocationUtils
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 06/05/2021.
//

import CoreLocation

public protocol LocationManagerProtocol: AnyObject {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    func start()
    func stop()
    func requestAlwaysAuthorization()
    func isAuthorized() -> Bool
    var didChangeAuthorization: ((CLAccuracyAuthorization, CLAuthorizationStatus) -> Void)? { get set }
    var didUpdateCurrentLocation: ((CLLocation) -> Void)? { get set }
    var didFailWithError: ((Error) -> Void)? { get set }
}

public final class RegionMonitoringLocationManager: NSObject {
    private var locationManager: CLLocationManagerProtocol
    private let regionMonitoringRadius: Double
    private var currentRegion: CLCircularRegion?
    private var currentLocation: CLLocation? {
        didSet {
            guard let currentLocation = currentLocation else { return }
            // if there is a currentRegion stop monitoring
            if let currentRegion = currentRegion {
                locationManager.stopMonitoring(for: currentRegion)
            }
            // create new region and assign to current region
            currentRegion = CLCircularRegion(
                center: currentLocation.coordinate,
                radius: regionMonitoringRadius,
                identifier: "currentRegion"
            )
            
            currentRegion?.notifyOnExit = true
            // start monitoring the new regin
            if let currentRegion = currentRegion {
                locationManager.startMonitoring(for: currentRegion)
            }
        }
    }

    public var didChangeAuthorization: ((CLAccuracyAuthorization, CLAuthorizationStatus) -> Void)?
    public var didUpdateCurrentLocation: ((CLLocation) -> Void)?
    public var didFailWithError: ((Error) -> Void)?

    public init(
        radius: Double,
        locationManager: CLLocationManagerProtocol = CLLocationManager()
    ) {
        regionMonitoringRadius = radius
        self.locationManager = locationManager
        super.init()
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.activityType = .fitness
        self.locationManager.delegate = self
    }
}

extension RegionMonitoringLocationManager: LocationManagerProtocol, CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        didChangeAuthorization?(manager.accuracyAuthorization, manager.authorizationStatus)
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            didUpdateCurrentLocation?(location)
            currentLocation = location
        }
    }

    public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        locationManager.requestLocation()
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        didFailWithError?(error)
        handleError()
    }

    private func handleError() {
        // retry to capture location after 30 seconds if an error occurs as fallback
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) { [weak self] in
            self?.locationManager.requestLocation()
        }
    }

    public func requestAlwaysAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }

    public func start() {
        currentRegion = nil
        currentLocation = nil
        locationManager.requestLocation()
    }

    public func stop() {
        guard let currentRegion = currentRegion else { return }
        locationManager.stopMonitoring(for: currentRegion)
        self.currentRegion = nil
        self.currentLocation = nil
    }

    public func isAuthorized() -> Bool {
        (locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse) && locationManager.accuracyAuthorization == .fullAccuracy
    }
}
