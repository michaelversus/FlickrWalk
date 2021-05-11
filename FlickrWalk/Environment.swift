//
//  Environment.swift
//  FlickrWalk
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 06/05/2021.
//

import Foundation
import LocationUtils
import Networking
import CommonUtils

protocol EnvironmentProtocol {
    var locationManager: LocationManagerProtocol { get }
}

/// A Structure that encapsulates all environment & user specific singletons and classes.
final class Environment: EnvironmentProtocol {
    let locationManager: LocationManagerProtocol
    let urlSession: URLSessionProtocol
    let fileManager: FileManagerProtocol

    /// Returns the current environment.
    static let current: Environment = Environment()

    /// This initializer is private on purpose. No one should be able to create environments except this class
    private init(
        locationManager: LocationManagerProtocol = RegionMonitoringLocationManager(radius: 100),
        urlSession: URLSessionProtocol = URLSession.shared,
        fileManager: FileManagerProtocol = FileManager.default
    ) {
        self.locationManager = locationManager
        self.urlSession = urlSession
        self.fileManager = fileManager
    }
}
