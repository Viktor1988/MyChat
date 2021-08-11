//
//  MMessage.swift
//  MyChat
//
//  Created by Виктор Попов on 09.08.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

struct MMessage: Hashable {

    var content: String
    var senderId: String
    var senderUserName: String
    let sentDate: Date
    let id: String?
    
    init(user:MUser, content: String) {
        self.content = content
        senderId = user.id
        senderUserName = user.username
        sentDate = Date()
        id = nil
        self.content = content
    }
    
    init?(document: QueryDocumentSnapshot) {
           let data = document.data()
           guard let sentDate = data["created"] as? Timestamp else { return nil}
           guard let senderId = data["senderId"] as? String else { return  nil}
           guard let senderUsername = data["senderName"] as? String else { return nil}
           guard let content = data["content"] as? String else { return nil}
           
           self.id = document.documentID
           self.sentDate = sentDate.dateValue()
        self.senderId = senderId
        self.senderUserName = senderUsername
           self.content = content
       }
    
    var representation: [String: Any] {
        let rep: [String : Any] = [
            "created" : sentDate,
            "senderId" : senderId,
            "senderName" : senderUserName,
            "content" : content
        ]
        return rep
    }
}
