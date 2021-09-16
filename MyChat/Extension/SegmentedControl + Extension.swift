//
//  SegmentedControl + Extension.swift
//  MyChat
//
//  Created by Виктор Попов on 29.07.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit


extension UISegmentedControl {
    
    convenience init(first: String, second: String) {
        self.init()
        
        insertSegment(withTitle: first, at: 0, animated: true)
        insertSegment(withTitle: second, at: 1, animated: true)
        selectedSegmentIndex = 0
    }
}
