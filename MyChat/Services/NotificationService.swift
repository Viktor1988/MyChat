//
//  NotificationService.swift
//  MyChat
//
//  Created by Виктор Попов on 11.08.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit
import UserNotifications


class NotificationService: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()

    func scheduleNotification(chat: MChat, message: MMessage) {
        
        let identifire = "New message"
        notificationCenter.addObserver(self, forKeyPath: identifire, options: .new, context: .none)
        let content = UNMutableNotificationContent()
        
        content.title = "Вам написал(а): \(chat.friendUsername)"
        content.body = "Текст Сообщения: \(message.content)"
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
       
        let request = UNNotificationRequest(identifier: identifire,
                                            content: content,
                                            trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotificationAwairingChats(chat: MChat) {
        
        let identifire = "New Chat"
        let content = UNMutableNotificationContent()
        content.title = "\(chat.friendUsername) отправил заявку на дружбу"
        content.body = "Текст Сообщения: \(chat.lastMessageContent)"
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifire,
                                            content: content,
                                            trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotificationNewMessage() {
        
        let identifire = "NewMessageToChat"
        let content = UNMutableNotificationContent()
        content.title = "Новое сообщение"
        content.body = "Прочитайте новое сообщение"
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifire,
                                            content: content,
                                            trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
}

