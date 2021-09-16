//
//  InsertableTextField.swift
//  MyChat
//
//  Created by Виктор Попов on 03.08.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit

class InsertableTextField: UITextField{
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        placeholder = "Write somethind here..."
        font = UIFont.systemFont(ofSize: 14)
        clearButtonMode = .whileEditing
        borderStyle = .none
        layer.cornerRadius = 18
        layer.masksToBounds = true
        
        let image = UIImage(systemName: "smiley")
        let imageView = UIImageView(image: image)
        imageView.setupColor(color: .lightGray)
        leftView = imageView
        leftView?.frame = CGRect(x: 0, y: 0, width: 19, height: 19)
        leftViewMode = .always
        
        
        
        
        let button = UIButton(type: .system)
        button.applyGradients(cornerRarius: 10)
        button.setImage(UIImage(named: "Sent"), for: .normal)
        
        rightView = button
        rightView?.frame = CGRect(x: 0, y: 0, width: 19, height: 19)
        rightViewMode = .always
        
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        
        return rect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 12
        return rect
    }
        
    override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 36, dy: 0)
        }
        
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 36, dy: 0)
        }
        
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 36, dy: 0)
        }
        
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
