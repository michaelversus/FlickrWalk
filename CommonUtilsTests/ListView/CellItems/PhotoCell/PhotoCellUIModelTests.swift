//
//  PhotoCellUIModelTests.swift
//  CommonUtilsTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import XCTest
import CommonUtils

class PhotoCellUIModelTests: XCTestCase {

    func test_configure() throws {
        // Given
        let image = try XCTUnwrap(UIImage(systemName: "pencil"))
        let photoCell = PhotoCell()
        let sut = PhotoCellUIModel(image: image, id: "id")

        // When
        XCTAssertNil(photoCell.photoView.image)
        sut.configure(photoCell)

        // Then
        XCTAssertEqual(photoCell.photoView.image, image)
    }
}
