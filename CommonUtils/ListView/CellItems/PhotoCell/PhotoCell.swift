//
//  PhotoCell.swift
//  CommonUtils
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 10/05/2021.
//

import UIKit

final public  class PhotoCell: UITableViewCell {

    let photoView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .clear
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
fileprivate extension PhotoCell {
    func setupUI() {
        self.addSubview(photoView)
        photoView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        photoView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        photoView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        photoView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
    }
}
