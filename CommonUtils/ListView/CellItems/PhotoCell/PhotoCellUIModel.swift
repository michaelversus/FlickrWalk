//
//  PhotoCellUIModel.swift
//  CommonUtils
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 10/05/2021.
//

import UIKit

public struct PhotoCellUIModel {
    let image: UIImage
    let id: String

    public init(image: UIImage, id: String) {
        self.image = image
        self.id = id
    }
}

extension PhotoCellUIModel {
    public func configure(_ cell: PhotoCell) {
        cell.photoView.image = image
    }
}

extension PhotoCellUIModel: Equatable {
    public static func == (lhs: PhotoCellUIModel, rhs: PhotoCellUIModel) -> Bool {
        return  lhs.id == rhs.id
    }
}
