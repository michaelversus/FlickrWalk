//
//  CLLocationManagerProtocol.swift
//  LocationUtils
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 10/05/2021.
//

import CoreLocation

public protocol CLLocationManagerProtocol {
    var allowsBackgroundLocationUpdates: Bool { get set }
    var desiredAccuracy: CLLocationAccuracy { get set }
    var activityType: CLActivityType { get set }
    var delegate: CLLocationManagerDelegate? { get set }
    var authorizationStatus: CLAuthorizationStatus { get }
    var accuracyAuthorization: CLAccuracyAuthorization { get }
    func stopMonitoring(for region: CLRegion)
    func startMonitoring(for region: CLRegion)
    func requestLocation()
    func requestAlwaysAuthorization()
}

extension CLLocationManager: CLLocationManagerProtocol {}
