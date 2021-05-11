//
//  CellItemTests.swift
//  CommonUtilsTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import XCTest
import CommonUtils

class CellItemTests: XCTestCase {

    func test_photoCell() throws {
        // Given
        let image = try XCTUnwrap(UIImage(systemName: "pencil"))
        let uiModel = PhotoCellUIModel(image: image, id: "id")

        // When
        let sut = CellItem.photoCell(uiModel)

        // Then
        XCTAssertEqual(sut.cellDescriptor.reuseIdentifier, "photoCell")
    }
}
