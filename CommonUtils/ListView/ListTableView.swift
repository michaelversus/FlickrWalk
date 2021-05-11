//
//  ListTableView.swift
//  CommonUtils
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 10/05/2021.
//

import UIKit

final public class ListTableView<Item>: UITableView {
    public var items: [Item] = []
    public let cellDescriptor: (Item) -> CellDescriptor
    public var reuseIdentifiers: Set<String> = []

    public init(items: [Item], cellDescriptor: @escaping (Item) -> CellDescriptor) {
        self.cellDescriptor = cellDescriptor
        super.init(frame: .zero, style: .plain)
        self.items = items
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
