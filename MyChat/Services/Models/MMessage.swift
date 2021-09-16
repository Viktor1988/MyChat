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
import MessageKit

struct MMessage: Hashable, MessageType  {
    
    
    var sender: SenderType
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var kind: MessageKind {
        return .text(content)
    }
    

    var content: String
    let sentDate: Date
    let id: String?
    
    init(user:MUser, content: String) {
        self.content = content
        sender = Sender(senderId: user.id, displayName: user.username)
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
        sender = Sender(senderId: senderId, displayName: senderUsername)
           self.content = content
       }
    
    var representation: [String: Any] {
        let rep: [String : Any] = [
            "created" : sentDate,
            "senderId" : sender.senderId,
            "senderName" : sender.displayName,
            "content" : content
        ]
        return rep
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    static func == (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
}

extension MMessage : Comparable {
    static func < (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
    
}



//struct MMessage: Hashable {
//
//    var content: String
//    var senderId: String
//    var senderUserName: String
//    let sentDate: Date
//    let id: String?
//
//    init(user:MUser, content: String) {
//        self.content = content
//        senderId = user.id
//        senderUserName = user.username
//        sentDate = Date()
//        id = nil
//        self.content = content
//    }
//
//    init?(document: QueryDocumentSnapshot) {
//           let data = document.data()
//           guard let sentDate = data["created"] as? Timestamp else { return nil}
//           guard let senderId = data["senderId"] as? String else { return  nil}
//           guard let senderUsername = data["senderName"] as? String else { return nil}
//           guard let content = data["content"] as? String else { return nil}
//
//           self.id = document.documentID
//           self.sentDate = sentDate.dateValue()
//        self.senderId = senderId
//        self.senderUserName = senderUsername
//           self.content = content
//       }
//
//    var representation: [String: Any] {
//        let rep: [String : Any] = [
//            "created" : sentDate,
//            "senderId" : senderId,
//            "senderName" : senderUserName,
//            "content" : content
//        ]
//        return rep
//    }
//}
