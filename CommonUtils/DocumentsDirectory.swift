//
//  DocumentsDirectory.swift
//  CommonUtils
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 10/05/2021.
//

import UIKit

public protocol FileManagerProtocol {
    func saveJPG(
        image: UIImage,
        filename: String
    ) throws

    func loadJPG(
        filename: String
    ) throws -> UIImage
}

extension FileManager: FileManagerProtocol {
    enum Error: Swift.Error {
        case invaliDirectoryURL
        case failedJpegData
        case failedToLoadData
        case invalidImageData
    }

    private func url(directory: FileManager.SearchPathDirectory) -> URL? {
        let paths = urls(for: directory, in: .userDomainMask)
        return paths.first
    }

    private func fileURL(
        for filename: String
    ) throws -> URL {
        guard let documentURL = url(directory: .documentDirectory) else { throw Error.invaliDirectoryURL }
        return documentURL.appendingPathComponent("\(filename)")
    }

    public func saveJPG(
        image: UIImage,
        filename: String
    ) throws {
        guard let directoryURL = url(directory: .documentDirectory) else { throw Error.invaliDirectoryURL }
        guard let data = image.jpegData(compressionQuality: 0.8) else { throw Error.failedJpegData }
        let fileURL = directoryURL.appendingPathComponent("\(filename)")
        try data.write(to: fileURL)
    }

    public func loadJPG(
        filename: String
    ) throws -> UIImage {
        let url = try fileURL(for: filename)
        guard let data = contents(atPath: url.path) else { throw Error.failedToLoadData }
        guard let image = UIImage(data: data) else { throw Error.invalidImageData }
        return image
    }
}
