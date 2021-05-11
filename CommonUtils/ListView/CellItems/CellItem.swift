//
//  CellItem.swift
//  CommonUtils
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 10/05/2021.
//

import UIKit

public enum CellItem {
    case photoCell(PhotoCellUIModel)
}

extension CellItem {
    public var cellDescriptor: CellDescriptor {
        switch self {
        case .photoCell(let uiModel):
            return CellDescriptor(reuseIdentifier: "photoCell", configure: uiModel.configure, cellRatio: uiModel.image.getImageRatio)
        }
    }
}

extension CellItem: Equatable {}
