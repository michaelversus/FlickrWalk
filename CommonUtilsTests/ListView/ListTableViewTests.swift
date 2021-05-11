//
//  ListTableViewTests.swift
//  CommonUtilsTests
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import XCTest
import CommonUtils

class ListTableViewTests: XCTestCase {

    func test_init() {
        // Given
        let items: [CellItem] = [
            .photoCellMock,
            .photoCellMock
        ]
        let reuseIdentifier = "photoCell"
        let descriptor: (CellItem) -> CellDescriptor = { $0.cellDescriptor }

        // When
        let sut = ListTableView(
            items: items,
            cellDescriptor: descriptor
        )

        // Then
        XCTAssertEqual(sut.items, items)
        XCTAssertEqual(sut.cellDescriptor(.photoCellMock).reuseIdentifier, reuseIdentifier)
    }
}

extension CellItem {
    static let photoCellMock: CellItem = {
        let image = UIImage(systemName: "pencil")!
        let uiModel = PhotoCellUIModel(image: image, id: "id")
        let item = CellItem.photoCell(uiModel)
        return item
    }()
}
