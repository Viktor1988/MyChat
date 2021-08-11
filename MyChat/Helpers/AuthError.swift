//
//  AuthError.swift
//  MyChat
//
//  Created by Виктор Попов on 03.08.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit


enum AuthError {
    case notFilled
    case invalidateEmail
    case passwordNotMatched
    case unknownError
    case serverError
}

extension AuthError: LocalizedError {
    var errorDescription: String?  {
        switch self {
        
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .invalidateEmail:
            return NSLocalizedString("Email заполнен неверно", comment: "")
        case .passwordNotMatched:
            return NSLocalizedString("Пароли не совпадают", comment: "")
        case .unknownError:
            return NSLocalizedString("Неизвестная ошибка", comment: "")
        case .serverError:
            return NSLocalizedString("Проблемы с сервером", comment: "")
        }
    }
}
