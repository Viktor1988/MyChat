//
//  SelfConfiguringCell.swift
//  MyChat
//
//  Created by Виктор Попов on 02.08.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit

protocol SelfConfigureCell {
    static var reuseId: String { get }
    func configure<U: Hashable>(with value: U)
}
