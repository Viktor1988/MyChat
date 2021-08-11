//
//  UILabel + Extension.swift
//  MyChat
//
//  Created by Виктор Попов on 27.07.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont? = .avenir20()) {
        self.init()
        
        self.text = text
        self.font = font
    }
    
}

