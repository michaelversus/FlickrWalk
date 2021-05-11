//
//  ListViewTests.swift
//  CommonUtilsTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import XCTest
import CommonUtils

class ListViewTests: XCTestCase {

    func test_init() {
        // Given
        let items: [CellItem] = [
            .photoCellMock,
            .photoCellMock
        ]

        // When
        let sut = ListView(items: items)

        // Then
        XCTAssertEqual(sut.tableView.items, items)
        XCTAssertFalse(sut.tableView.translatesAutoresizingMaskIntoConstraints)
        XCTAssertEqual(sut.tableView.separatorStyle, .none)
        XCTAssertEqual(sut.tableView.backgroundColor, .clear)
        XCTAssertFalse(sut.tableView.bounces)
        XCTAssertTrue(sut.tableView.delegate is ListView)
        XCTAssertTrue(sut.tableView.dataSource is ListView)
    }

    func test_numberOfRowsInSection() {
        // Given
        let items: [CellItem] = [
            .photoCellMock,
            .photoCellMock
        ]
        let sut = ListView(items: items)

        // When
        let numberOfRowsInSection = sut.tableView(sut.tableView, numberOfRowsInSection: 0)

        // Then
        XCTAssertEqual(numberOfRowsInSection, 2)
    }

    func test_cellForRowAt_indexPath() throws {
        // Given
        let items: [CellItem] = [
            .photoCellMock,
            .photoCellMock
        ]
        let sut = ListView(items: items)

        // When
        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let photoCell = try XCTUnwrap(cell as? PhotoCell)

        XCTAssertEqual(photoCell.photoView.image, UIImage(systemName: "pencil"))
    }

    func test_heightForRowAt_indexPath() {
        // Given
        let items: [CellItem] = [
            .photoCellMock,
            .photoCellMock
        ]
        let sut = ListView(items: items)

        // When
        let height = sut.tableView(sut.tableView, heightForRowAt: IndexPath(row: 0, section: 0))

        // Then
        XCTAssertEqual(height, 0)
    }

    func test_insert() {
        // Given
        let items: [CellItem] = [
            .photoCellMock,
            .photoCellMock
        ]
        let sut = ListView(items: items)

        // When
        sut.insert(item: .photoCellMock, at: 0)

        // Then
        let expectedItems: [CellItem] = [
            .photoCellMock,
            .photoCellMock,
            .photoCellMock
        ]
        XCTAssertEqual(sut.tableView.items, expectedItems)
    }
}
