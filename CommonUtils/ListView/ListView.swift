//
//  ListView.swift
//  CommonUtils
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 10/05/2021.
//

import UIKit

final public class ListView: NSObject, UITableViewDelegate, UITableViewDataSource {
    public let tableView: ListTableView<CellItem>

    public init(
        items: [CellItem] = [],
        cellDescriptor: @escaping (CellItem) -> CellDescriptor = { $0.cellDescriptor }
    ) {
        self.tableView = ListTableView(items: items, cellDescriptor: cellDescriptor)
        super.init()
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .clear
        self.tableView.bounces = false
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableView.items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.tableView.items[indexPath.row]
        let descriptor = self.tableView.cellDescriptor(item)
        if !self.tableView.reuseIdentifiers.contains(descriptor.reuseIdentifier) {
            tableView.register(descriptor.cellClass, forCellReuseIdentifier: descriptor.reuseIdentifier)
            self.tableView.reuseIdentifiers.insert(descriptor.reuseIdentifier)
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: descriptor.reuseIdentifier, for: indexPath)
        descriptor.configure(cell)
        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.tableView.items[indexPath.row]
        let descriptor = self.tableView.cellDescriptor(item)
        if let cellRatio = descriptor.cellRatio?() {
            return self.tableView.frame.width / cellRatio
        } else {
            return 100
        }
    }

    public func insert(item: CellItem, at index: Int) {
        self.tableView.items.insert(item, at: index)
        self.tableView.reloadData()
    }
}

