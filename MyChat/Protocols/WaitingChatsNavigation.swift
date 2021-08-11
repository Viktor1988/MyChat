//
//  WaitingChatsNavigation.swift
//  MyChat
//
//  Created by Виктор Попов on 10.08.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit

protocol WaitingChatsNavigation:class {
    func removeWaitingChat(chat: MChat)
    func chatToActive(chat: MChat)
    
}
