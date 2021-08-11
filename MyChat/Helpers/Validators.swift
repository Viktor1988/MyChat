//
//  Validators.swift
//  MyChat
//
//  Created by Виктор Попов on 03.08.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit

class Validators {
    static func isFilled(email: String?, password: String?, confirmPassword: String?) -> Bool {
        guard
        let email = email,
        let password = password,
        let confirmPassword = confirmPassword,
        email != "",
        password != "",
        confirmPassword != "" else { return false }
        return true
    }
    
    static func isFilled(username: String?, description: String?, sex: String?) -> Bool {
        guard
        let username = username,
        let description = description,
        let sex = sex,
        username != "",
        description != "",
        sex != "" else { return false }
        return true
    }
    
    static func isSimpleEmail(_ email: String) -> Bool {
        let emailRegex = "^.+@.+\\..{2,}$"
        return check(text: email, regEx: emailRegex)
    }
    
    static func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text )
    }
}
