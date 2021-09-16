//
//  GeneralMethod.swift
//  MyChat
//
//  Created by Виктор Попов on 29.07.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit

class GeneralMethod {
    
    public func makeConstarintStackViewLabelWithButton(label: UILabel, button: UIButton, stackView: UIStackView) {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            label.topAnchor.constraint(equalTo: stackView.topAnchor),
        ])
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            button.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            button.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
