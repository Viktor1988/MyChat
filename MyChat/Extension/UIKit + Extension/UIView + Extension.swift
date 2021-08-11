//
//  UIView + Extension.swift
//  MyChat
//
//  Created by Виктор Попов on 30.07.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit

extension UIView {
    
    convenience init(label: UILabel, textField: UITextField, stackView: UIStackView) {
        self.init()
        makeConstarintStackViewLabeTextField(label: label, textField: textField, stackView: stackView)
    }
    
    public func makeConstarintStackViewLabeTextField(label: UILabel, textField: UITextField, stackView: UIStackView) {
        label.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            label.topAnchor.constraint(equalTo: stackView.topAnchor),
        ])
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            textField.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            textField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func applyGradients(cornerRarius: CGFloat) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        
        let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: #colorLiteral(red: 0.5568627451, green: 0.3529411765, blue: 0.5607843137, alpha: 1), endColor: #colorLiteral(red: 0.3529411765, green: 0.7647058824, blue: 1, alpha: 1))
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = self.bounds
            gradientLayer.cornerRadius = cornerRarius
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
        
    }
}
