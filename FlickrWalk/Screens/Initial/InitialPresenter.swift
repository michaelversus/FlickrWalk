//
//  InitialPresenter.swift
//  FlickrWalk
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 06/05/2021.
//

import Foundation
import CoreLocation
import LocationUtils

protocol InitialPresenterProtocol {
    func attach(_ view: InitialViewProtocol)
    func initialLoad()
    func load()
}

final class InitialPresenter: InitialPresenterProtocol {
    weak private var view: InitialViewProtocol?
    private let locationManager: LocationManagerProtocol

    init(
        locationManager: LocationManagerProtocol = Environment.current.locationManager
    ) {
        self.locationManager = locationManager
        self.locationManager.didChangeAuthorization = { [weak self] accuracy, status in
            self?.didChangeAuthorization(accuracy: accuracy, status: status)
        }
        self.locationManager.didFailWithError = { [weak self] error in
            self?.didFailWithError(error: error)
        }
    }

    func attach(_ view: InitialViewProtocol) {
        assert(self.view == nil, "Should not attach view twice")
        self.view = view
    }

    func initialLoad() {
        view?.setupTitle(text: "Flickr Walk")
        view?.setupButtonTitle(text: "START")
    }

    func load() {
        if !self.locationManager.isAuthorized() {
            self.locationManager.requestAlwaysAuthorization()
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.view?.goToPhotos()
            }
        }
    }

    func didChangeAuthorization(accuracy: CLAccuracyAuthorization, status: CLAuthorizationStatus) {
        DispatchQueue.main.async { [weak self] in
            guard status == .authorizedAlways || status == .authorizedWhenInUse else {
                self?.view?.presentAlert(with: "Caution", message: "The app needs authorization for your location to work as expected")
                return
            }
            guard accuracy == .fullAccuracy else {
                self?.view?.presentAlert(with: "Caution", message: "The app needs full accuracy for your location to work as expected")
                return
            }
            self?.view?.goToPhotos()
        }
    }

    func didFailWithError(error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.presentAlert(with: "Caution", message: "Something went wrong")
        }
    }
}
