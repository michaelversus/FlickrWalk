//
//  UIButton+Extension.swift
//  CommonUtils
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 06/05/2021.
//

import UIKit

extension UIButton {
    convenience public init(
        title: String,
        titleColor: UIColor,
        font: UIFont = .systemFont(ofSize: 14),
        backgroundColor: UIColor = .clear,
        target: Any? = nil,
        action: Selector? = nil
    ) {
        self.init(type: .system)
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font

        self.backgroundColor = backgroundColor
        if let action = action {
            addTarget(target, action: action, for: .primaryActionTriggered)
        }
    }
}
