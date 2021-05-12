//
//  MockFileManager.swift
//  FlickrWalkTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import UIKit
import CommonUtils
@testable import FlickrWalk

final class MockFileManager: FileManagerProtocol {
    var image: UIImage?
    var filename: String?
    var error: Error?

    public init(image: UIImage, filename: String, error: Error?) {
        self.image = image
        self.filename = filename
        self.error = error
    }

    func saveJPG(image: UIImage, filename: String) throws {
        if let error = error {
            throw error
        }
        self.image = image
        self.filename = filename
    }

    func loadJPG(filename: String) throws -> UIImage {
        if let error = error {
            throw error
        }
        if filename == self.filename, let image = self.image {
            return image
        }
        throw MockFileManagerError()
    }

    func clearAllImages() throws {
        if let error = error {
            throw error
        }
        self.image = nil
        self.filename = nil
    }
}

struct MockFileManagerError: Error {}
