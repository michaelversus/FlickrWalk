//
//  UIImageExtensionTests.swift
//  CommonUtilsTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import XCTest
import CommonUtils

class UIImageExtensionTests: XCTestCase {

    func test_getImageRatio() throws {
        // Given
        let image = UIImage(systemName: "pencil")

        // When
        let ratio: CGFloat = try XCTUnwrap(image?.getImageRatio())

        // Then
        XCTAssertEqual(ratio, 1.1304347826086956)
    }
}
