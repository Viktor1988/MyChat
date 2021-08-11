//
//  MChat.swift
//  MyChat
//
//  Created by Виктор Попов on 02.08.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit
import FirebaseFirestore

struct MChat: Hashable, Decodable {
    
    var friendUsername: String
    var friendAvatarStringUrl: String
    var lastMessageContent: String
    var friendId: String
    
    var representation: [String: Any] {
        var rep = ["friendUsername": friendUsername]
        rep["friendAvatarStringUrl"] = friendAvatarStringUrl
        rep["friendId"] = friendId
        rep["lastMessage"] = lastMessageContent
        return rep
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let friendUsername = data["friendUsername"] as? String else { return nil }
        guard let friendAvatarStringUrl = data["friendAvatarStringUrl"] as? String else { return nil }
        guard let lastMessageContent = data["lastMessage"] as? String else { return nil }
        guard let friendId = data["friendId"] as? String else { return nil }
        
        self.friendUsername = friendUsername
        self.lastMessageContent = lastMessageContent
        self.friendAvatarStringUrl = friendAvatarStringUrl
        self.friendId = friendId
    }
    
    init(friendUsername: String, friendAvatarStringUrl: String, lastMessageContent: String ,friendId: String) {
        self.friendUsername = friendUsername
        self.friendAvatarStringUrl = friendAvatarStringUrl
        self.lastMessageContent = lastMessageContent
        self.friendId = friendId
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    
    static func == (lhs: MChat, rhs:MChat) -> Bool {
        return lhs.friendId == rhs.friendId
    }
    
}
