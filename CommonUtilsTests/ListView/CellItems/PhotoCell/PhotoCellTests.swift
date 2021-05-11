//
//  PhotoCellTests.swift
//  CommonUtilsTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import XCTest
import CommonUtils

class PhotoCellTests: XCTestCase {

    func test_init() {
        // Given, When
        let sut = PhotoCell()

        // Then
        XCTAssertEqual(sut.backgroundColor, .clear)
        XCTAssertEqual(sut.contentView.backgroundColor, .clear)
        XCTAssertEqual(sut.selectionStyle, .none)
        XCTAssertNil(sut.photoView.image)
    }

}
