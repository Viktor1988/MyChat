//
//  UserError.swift
//  MyChat
//
//  Created by Виктор Попов on 04.08.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import Foundation

enum UserError {
    case notFilled
    case photonotExist
    case cannotGertUserInfo
    case cannotUnwraptToMUser
}

extension UserError: LocalizedError {
    var errorDescription: String?  {
        switch self {
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .photonotExist:
            return NSLocalizedString("Загрузите фото", comment: "")
        case .cannotGertUserInfo:
            return NSLocalizedString("Не удалется получить данные из FireBase", comment: "")
        case .cannotUnwraptToMUser:
            return NSLocalizedString("Не удалется пконвертировать данные в MUSer из User", comment: "")
        }
    }
}
