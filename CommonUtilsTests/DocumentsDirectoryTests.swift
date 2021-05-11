//
//  DocumentsDirectoryTests.swift
//  CommonUtilsTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import XCTest
import CommonUtils

class DocumentsDirectoryTests: XCTestCase {

    let sut: FileManager = FileManager.default

    override func setUpWithError() throws {
        
    }

    func test_save_load() throws {
        // Given
        let testImage: UIImage = try XCTUnwrap(UIImage(systemName: "pencil"))

        // When
        try sut.saveJPG(image: testImage, filename: "testImage.jpg")
        let image = try sut.loadJPG(filename: "testImage.jpg")

        // Then
        XCTAssertNotNil(image)
    }

    func test_load_failure() throws {
        // Given
        let fakeFilename = "test.jpg"

        // When, Then
        XCTAssertThrowsError(try sut.loadJPG(filename: fakeFilename))
    }

}
