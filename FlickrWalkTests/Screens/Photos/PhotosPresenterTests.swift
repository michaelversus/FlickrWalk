//
//  PhotosPresenterTests.swift
//  FlickrWalkTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import XCTest
import CoreLocation
import CommonUtils
@testable import FlickrWalk

class PhotosPresenterTests: XCTestCase {

    var printMessage: String?

    override func setUpWithError() throws {
        printMessage = nil
    }

    func test_initialLoad() throws {
        // Given
        let locationManager = MockLocationManager()
        let urlSession = MockURLSession(results: [.failure(UnknownDecodingError())])
        let image = try XCTUnwrap(UIImage(systemName: "pencil"))
        let fileManager = MockFileManager(image: image, filename: "pencil.jpg", error: nil)
        let sut = PhotosPresenter(
            locationManager: locationManager,
            urlSession: urlSession,
            fileManager: fileManager,
            mainQueue: MockMainQueue()
        )
        let view = MockPhotosViewController()
        sut.attach(view)

        // When
        sut.initialLoad()

        // Then
        let expectedViewActions: [MockPhotosViewController.Action] = [
            .setupTitle(text: "Photos"),
            .setupStopButton(title: "Stop")
        ]
        let expectedLocationActions: [MockLocationManager.Action] = [
            .start
        ]
        XCTAssertEqual(view.actions, expectedViewActions)
        XCTAssertEqual(locationManager.actions, expectedLocationActions)
    }

    func test_stopUpdates() throws {
        // Given
        let locationManager = MockLocationManager()
        let urlSession = MockURLSession(results: [.failure(UnknownDecodingError())])
        let image = try XCTUnwrap(UIImage(systemName: "pencil"))
        let fileManager = MockFileManager(image: image, filename: "pencil.jpg", error: nil)
        let sut = PhotosPresenter(
            locationManager: locationManager,
            urlSession: urlSession,
            fileManager: fileManager,
            mainQueue: MockMainQueue()
        )
        let view = MockPhotosViewController()
        sut.attach(view)

        // When
        sut.stopUpdates()

        // Then
        let expectedLocationActions: [MockLocationManager.Action] = [
            .stop
        ]
        XCTAssertNil(fileManager.image)
        XCTAssertNil(fileManager.filename)
        XCTAssertEqual(locationManager.actions, expectedLocationActions)
    }

    func test_didUpdateCurrentLocation_givenUrlSessionReturnsError() throws {
        // Given
        let locationManager = MockLocationManager()
        let urlSession = MockURLSession(results: [.failure(UnknownDecodingError())])
        let image = try XCTUnwrap(UIImage(systemName: "pencil"))
        let fileManager = MockFileManager(image: image, filename: "pencil.jpg", error: nil)
        let sut = PhotosPresenter(
            locationManager: locationManager,
            urlSession: urlSession,
            fileManager: fileManager,
            mainQueue: MockMainQueue(),
            silentPrint: { [weak self] msg in self?.printMessage = msg }
        )
        let view = MockPhotosViewController()
        sut.attach(view)

        // When
        sut.didUpdateCurrentLocation(location: CLLocation.apple)

        //Then
        XCTAssertEqual(printMessage, "silent failure")
    }

    func test_didUpdateCurrentLocation_givenUrlSessionReturnsErrorInsteadOfImageData() throws {
        // Given
        let locationManager = MockLocationManager()
        let model = try Flickr.mock()
        let urlSession = MockURLSession(results: [.success(model), .failure(UnknownDecodingError())])
        let image = try XCTUnwrap(UIImage(systemName: "pencil"))
        let fileManager = MockFileManager(image: image, filename: "pencil.jpg", error: nil)
        let sut = PhotosPresenter(
            locationManager: locationManager,
            urlSession: urlSession,
            fileManager: fileManager,
            mainQueue: MockMainQueue(),
            silentPrint: { [weak self] msg in self?.printMessage = msg }
        )
        let view = MockPhotosViewController()
        sut.attach(view)

        // When
        sut.didUpdateCurrentLocation(location: CLLocation.apple)

        //Then
        XCTAssertEqual(printMessage, "silent failure")
    }

    func test_didUpdateCurrentLocation_givenUrlSessionReturnsInvalidFlickrData() throws {
        // Given
        let locationManager = MockLocationManager()
        let model = try Flickr.invalidMock()
        let urlSession = MockURLSession(results: [.success(model), .failure(UnknownDecodingError())])
        let image = try XCTUnwrap(UIImage(systemName: "pencil"))
        let fileManager = MockFileManager(image: image, filename: "pencil.jpg", error: nil)
        let sut = PhotosPresenter(
            locationManager: locationManager,
            urlSession: urlSession,
            fileManager: fileManager,
            mainQueue: MockMainQueue(),
            silentPrint: { [weak self] msg in self?.printMessage = msg }
        )
        let view = MockPhotosViewController()
        sut.attach(view)

        // When
        sut.didUpdateCurrentLocation(location: CLLocation.apple)

        //Then
        XCTAssertEqual(printMessage, "silent failure")
    }

    func test_didUpdateCurrentLocation_givenUrlSessionReturnsValidImageData() throws {
        // Given
        let locationManager = MockLocationManager()
        let model = try Flickr.mock()
        let urlSession = MockURLSession(
            results: [
                .success(model),
                .success(UIImage.pencilData)
            ]
        )
        let fileManager = MockFileManager(image: UIImage.mockImageFromData, filename: "pencil.jpg", error: nil)
        let sut = PhotosPresenter(
            locationManager: locationManager,
            urlSession: urlSession,
            fileManager: fileManager,
            mainQueue: MockMainQueue(),
            silentPrint: { [weak self] msg in self?.printMessage = msg }
        )
        let view = MockPhotosViewController()
        sut.attach(view)

        // When
        sut.didUpdateCurrentLocation(location: CLLocation.apple)

        //Then
        let uiModel = PhotoCellUIModel(image: UIImage.mockImageFromData, id: "1_secret.jpg")
        let expectedViewActions: [MockPhotosViewController.Action] = [
            .updateListView(cellItem: .photoCell(uiModel))
        ]
        XCTAssertEqual(fileManager.filename, "1_secret.jpg")
        XCTAssertEqual(view.actions, expectedViewActions)
    }

    func test_didUpdateCurrentLocation_givenUrlSessionReturnsInvalidImageData() throws {
        // Given
        let locationManager = MockLocationManager()
        let model = try Flickr.mock()
        let urlSession = MockURLSession(
            results: [
                .success(model),
                .success(Data())
            ]
        )
        let fileManager = MockFileManager(image: UIImage.mockImageFromData, filename: "pencil.jpg", error: nil)
        let sut = PhotosPresenter(
            locationManager: locationManager,
            urlSession: urlSession,
            fileManager: fileManager,
            mainQueue: MockMainQueue(),
            silentPrint: { [weak self] msg in self?.printMessage = msg }
        )
        let view = MockPhotosViewController()
        sut.attach(view)

        // When
        sut.didUpdateCurrentLocation(location: CLLocation.apple)

        //Then
        XCTAssertEqual(printMessage, "silent failure")
    }

    func test_didUpdateCurrentLocation_givenCachedImageData() throws {
        // Given
        let locationManager = MockLocationManager()
        let model = try Flickr.mock()
        let urlSession = MockURLSession(
            results: [
                .success(model),
                .success(UIImage.pencilData)
            ]
        )
        let fileManager = MockFileManager(image: UIImage.mockImageFromData, filename: "1_secret.jpg", error: nil)
        let sut = PhotosPresenter(
            locationManager: locationManager,
            urlSession: urlSession,
            fileManager: fileManager,
            mainQueue: MockMainQueue(),
            silentPrint: { [weak self] msg in self?.printMessage = msg }
        )
        let view = MockPhotosViewController()
        sut.attach(view)

        // When
        sut.didUpdateCurrentLocation(location: CLLocation.apple)

        //Then
        let uiModel = PhotoCellUIModel(image: UIImage.mockImageFromData, id: "1_secret.jpg")
        let expectedViewActions: [MockPhotosViewController.Action] = [
            .updateListView(cellItem: .photoCell(uiModel))
        ]
        XCTAssertEqual(view.actions, expectedViewActions)
    }
}

extension UIImage {
    static let mockPencil: UIImage = UIImage(systemName: "pencil")!
    static let pencilData: Data = mockPencil.jpegData(compressionQuality: 0.8)!
    static let mockImageFromData: UIImage = UIImage(data: pencilData)!
}

extension Flickr {
    static func mock() throws -> Flickr {
        let jsonString: String = """
        {
            "photos": {
                "page": 1,
                "pages": 2,
                "perpage": 1,
                "total": "total",
                "photo": [
                    {
                        "id": "1",
                        "owner": "owner",
                        "secret": "secret",
                        "server": "server",
                        "farm": 3,
                        "title": "title"
                    }
                ]
            },
            "stat": "3"
        }
        """
        return try jsonString.parseLiteral(type: Flickr.self)
    }

    static func invalidMock() throws -> Flickr {
        let jsonString: String = """
        {
            "photos": {
                "page": 1,
                "pages": 2,
                "perpage": 1,
                "total": "total",
                "photo": [

                ]
            },
            "stat": "3"
        }
        """
        return try jsonString.parseLiteral(type: Flickr.self)
    }
}
