//
//  AuthNavigationDelegate.swift
//  MyChat
//
//  Created by Виктор Попов on 04.08.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit

protocol AuthNavigationDelegate: AnyObject {
    func toLoginVC()
    func toSignUpVC()
}
