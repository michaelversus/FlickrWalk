//
//  UIButtonExtensionTests.swift
//  UIButtonExtensionTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 06/05/2021.
//

import XCTest
@testable import CommonUtils

class UIButtonExtensionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_convenience_init() throws {
        // Given
        let title = "title"
        let titleColor = UIColor.black
        let font = UIFont.systemFont(ofSize: 14)
        let backgroundColor = UIColor.red

        // When
        let sut = UIButton(
            title: title,
            titleColor: titleColor,
            font: font,
            backgroundColor: backgroundColor,
            target: nil,
            action: nil
        )

        // Then
        XCTAssertEqual(sut.currentTitle, title)
        XCTAssertEqual(sut.currentTitleColor, titleColor)
        XCTAssertEqual(sut.titleLabel?.font, font)
        XCTAssertEqual(sut.backgroundColor, backgroundColor)
    }
}
