//
//  CellDescriptor.swift
//  CommonUtils
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 10/05/2021.
//

import UIKit

public struct CellDescriptor {
    public let cellClass: UITableViewCell.Type
    public let reuseIdentifier: String
    public let configure: (UITableViewCell) -> Void
    public let cellRatio: (() -> CGFloat)?

    public init<Cell: UITableViewCell>(
        reuseIdentifier: String,
        configure: @escaping (Cell) -> Void,
        cellRatio: (() -> CGFloat)? = nil
    ) {
        self.cellClass = Cell.self
        self.reuseIdentifier = reuseIdentifier
        self.configure = { cell in
            configure(cell as! Cell)
        }
        self.cellRatio = cellRatio
    }
}

