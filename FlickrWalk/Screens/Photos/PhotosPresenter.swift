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
    private let mainQueue: DispatchQueueProtocol
    private let silentPrint: (String) -> Void

    enum Error: Swift.Error {
        case invalidURLString
        case invalidImageData
        case noImage
    }

    init(
        locationManager: LocationManagerProtocol = Environment.current.locationManager,
        urlSession: URLSessionProtocol = Environment.current.urlSession,
        fileManager: FileManagerProtocol = Environment.current.fileManager,
        mainQueue: DispatchQueueProtocol = Environment.current.mainQueue,
        silentPrint: @escaping (String) -> Void = { _ in } // here i could add a logger
    ) {
        self.fileManager = fileManager
        self.urlSession = urlSession
        self.locationManager = locationManager
        self.mainQueue = mainQueue
        self.silentPrint = silentPrint
        self.locationManager.didUpdateCurrentLocation = { [weak self] location in
            self?.didUpdateCurrentLocation(location: location)
        }
        self.locationManager.didFailWithError = { [weak self] error in
            self?.silentPrint(error.localizedDescription)
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

    func didUpdateCurrentLocation(location: CLLocation) {
        let api = FlickrAPI(location: location)
        guard let url = api.baseURL() else { return }
        let resource = Resource<Flickr>(
            json: .get,
            url: url,
            headers: [:],
            query: api.photoSearchQuery()
        )
        urlSession.load(resource) { [weak self] result in
            switch result {
            case .success(let flickr):
                guard let photo = flickr.photos.photo.first else {
                    self?.didDownloadImage(result: .failure(Error.noImage))
                    return
                }
                self?.downloadImage(
                    from: photo.urlString,
                    completion: { [weak self] in self?.didDownloadImage(result: $0) }
                )
            case .failure:
                self?.didDownloadImage(result: .failure(Error.noImage))
            }
        }
    }

    private func didDownloadImage(result: Result<(UIImage, String), Swift.Error>) {
        mainQueue.executeAsync { [weak self] in
            switch result {
            case .success((let image, let id)):
                let uiModel = PhotoCellUIModel(image: image, id: id)
                self?.view?.updateListView(cellItem: .photoCell(uiModel))
            case .failure:
                self?.silentPrint("silent failure")
                break
            }
        }
    }

    private func downloadImage(
        from urlString: String,
        completion: @escaping (Result<(UIImage, String), Swift.Error>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(Error.invalidURLString))
            return
        }
        if let image = try? fileManager.loadJPG(filename: url.lastPathComponent) {
            completion(.success((image, url.lastPathComponent)))
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
                    completion(.success((image, url.lastPathComponent)))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
