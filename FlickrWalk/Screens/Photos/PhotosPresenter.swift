//
//  PhotosPresenter.swift
//  FlickrWalk
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 06/05/2021.
//

import Foundation
import Networking
import LocationUtils
import CoreLocation
import CommonUtils
import UIKit

protocol PhotosPresenterProtocol {
    func attach(_ view: PhotosViewProtocol)
    func initialLoad()
    func stopUpdates()
}

final class PhotosPresenter: PhotosPresenterProtocol {
    weak private var view: PhotosViewProtocol?
    private let locationManager: LocationManagerProtocol
    private let urlSession: URLSessionProtocol
    private let fileManager: FileManagerProtocol

    enum Error: Swift.Error {
        case invalidURLString
        case invalidImageData
        case noImage
    }

    init(
        locationManager: LocationManagerProtocol = Environment.current.locationManager,
        urlSession: URLSessionProtocol = Environment.current.urlSession,
        fileManager: FileManagerProtocol = Environment.current.fileManager
    ) {
        self.fileManager = fileManager
        self.urlSession = urlSession
        self.locationManager = locationManager
        self.locationManager.didUpdateCurrentLocation = { [weak self] location in
            self?.didUpdateCurrentLocation(location: location)
        }
    }

    func attach(_ view: PhotosViewProtocol) {
        assert(self.view == nil, "Should not attach view twice")
        self.view = view
    }

    func initialLoad() {
        view?.setupTitle(text: "Photos")
        view?.setupStopButton(title: "Stop")
        locationManager.start()
    }

    func stopUpdates() {
        locationManager.stop()
    }

    private func didUpdateCurrentLocation(location: CLLocation) {
        let resource = Resource<Flickr>(
            json: .get,
            url: FlickrAPI.baseURL(),
            headers: [:],
            query: FlickrAPI.photoSearchQuery(location: location)
        )
        urlSession.load(resource) { [weak self] result in
            switch result {
            case .success(let flickr):
                dump(flickr)
                guard let photo = flickr.photos.photo.first else {
                    // TODO: special handling when image not found (maybe a placeholder)
                    self?.didDownloadImage(result: .failure(Error.noImage))
                    return
                }
                self?.downloadImage(
                    from: FlickrAPI.photoURLString(photo: photo),
                    completion: { [weak self] in self?.didDownloadImage(result: $0) }
                )
            case .failure:
                self?.didDownloadImage(result: .failure(Error.noImage))
            }
        }
    }

    private func didDownloadImage(result: Result<UIImage, Swift.Error>) {
        DispatchQueue.main.async { [weak self] in
            switch result {
            case .success(let image):
                let uiModel = PhotoCellUIModel(image: image)
                self?.view?.updateListView(cellItem: .photoCell(uiModel))
            case .failure:
                break
            }
        }
    }

    private func downloadImage(
        from urlString: String,
        completion: @escaping (Result<UIImage, Swift.Error>) -> Void
    ) {
        debugPrint(urlString)
        guard let url = URL(string: urlString) else {
            completion(.failure(Error.invalidURLString))
            return
        }
        if let image = try? fileManager.loadJPG(filename: url.lastPathComponent) {
            completion(.success(image))
            return
        }
        let resource = Resource<Data>(.get, url: url)
        urlSession.load(resource) { [weak self] result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completion(.failure(Error.invalidImageData))
                    return
                }
                do {
                    try self?.fileManager.saveJPG(image: image, filename: url.lastPathComponent)
                    completion(.success(image))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
