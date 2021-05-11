//
//  CellDescriptorTests.swift
//  CommonUtilsTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import XCTest
import CommonUtils

class CellDescriptorTests: XCTestCase {

    func test_init() {
        // Given
        let reuseIdentifier = "photoCell"
        let pencilImage = UIImage(systemName: "pencil")
        let configure: (PhotoCell) -> Void = { cell in
            cell.imageView?.image = pencilImage
        }
        let cell = PhotoCell()

        // When
        let sut = CellDescriptor(reuseIdentifier: reuseIdentifier, configure: configure)
        sut.configure(cell)
        // Then
        XCTAssertEqual(sut.reuseIdentifier, reuseIdentifier)
        XCTAssertTrue(sut.cellClass is PhotoCell.Type)
        XCTAssertNil(sut.cellRatio)
        XCTAssertEqual(cell.imageView?.image, pencilImage)
    }

}
