//
//  PhotoCellUIModel.swift
//  CommonUtils
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 10/05/2021.
//

import UIKit

public struct PhotoCellUIModel {
    let image: UIImage

    public init(image: UIImage) {
        self.image = image
    }
}

extension PhotoCellUIModel {
    public func configure(_ cell: PhotoCell) {
        cell.photoView.image = image
    }
}

extension PhotoCellUIModel: Equatable {}
