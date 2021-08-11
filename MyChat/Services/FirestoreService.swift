//
//  FirestoreService.swift
//  MyChat
//
//  Created by Виктор Попов on 04.08.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//


import Firebase
import FirebaseFirestore

class FirestoreService {
    
    static let shared = FirestoreService()
    
    let db = Firestore.firestore()
    
    var currentUser: MUser!
    
    private var waitingChatRef: CollectionReference {
        return db.collection(["users",currentUser.id,"waitingChats"].joined(separator: "/"))
    }
    private var activeChatRef: CollectionReference {
        return db.collection(["users",currentUser.id,"activeChats"].joined(separator: "/"))
    }
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    func saveProfileWith(id: String, email: String, username: String?, avatarImage: UIImage?, description: String?, sex: String?, completion: @escaping (Result<MUser, Error>) -> Void) {
        
        guard Validators.isFilled(username: username, description: description, sex: sex) else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        guard avatarImage != #imageLiteral(resourceName: "avatar") else {
            completion(.failure(UserError.photonotExist))
            return
        }
        
        
        var muser = MUser(
            username: username!,
            email: email,
            avatarStringURL: "not exist",
            description: description!,
            sex: sex!,
            id: id)
        
        StorageService.shared.upload(photo: avatarImage!) { (result) in
            switch result {
                
            case .success(let url):
                muser.avatarStringURL = url.absoluteString
                self.usersRef.document(muser.id).setData(muser.representation) { (error) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(muser))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    
    func getUserData(muser: User, completion: @escaping (Result<MUser, Error>) -> Void) {
        let docRef = usersRef.document(muser.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let muser = MUser(document: document) else {
                    completion(.failure(UserError.cannotUnwraptToMUser))
                    return
                }
                self.currentUser = muser
                completion(.success(muser))
            } else {
                completion(.failure(UserError.cannotGertUserInfo))
            }
        }
    }
    
    
    func crateWaitingChat(message: String, receiver: MUser,completion: @escaping (Result<Void, Error>) -> Void ) {
        let reference = db.collection(["users",receiver.id, "waitingChats"].joined(separator: "/"))
        let messageReferance = reference.document(self.currentUser.id).collection("messages")
        
        let message = MMessage(user: currentUser, content: message)
        let chat = MChat(friendUsername: currentUser.username,
                         friendAvatarStringUrl: currentUser.avatarStringURL,
                         lastMessageContent: message.content,
                         friendId: currentUser.id )
        reference.document(currentUser.id).setData(chat.representation) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            messageReferance.addDocument(data: message.representation) { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(Void()))
            }
        }
        
    }
    
    func deleteWaitingChat(chat: MChat,completion: @escaping (Result<Void, Error>) -> Void ) {
        waitingChatRef.document(chat.friendId).delete { (error) in
            if let error = error {
                completion(.failure(error.localizedDescription as! Error))
                return
            }
            completion(.success(Void()))
            self.deleteMessage(chat: chat, completion: completion)
        }
    }
    
    func getWaitingChatMessages(chat: MChat,completion: @escaping (Result<[MMessage], Error>) -> Void) {
        var messages = [MMessage]()
        let reference = waitingChatRef.document(chat.friendId).collection("messages")
        reference.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error.localizedDescription as! Error))
                return
            }
            for document in querySnapshot!.documents {
                guard let message = MMessage(document: document) else { return }
                messages.append(message)
            }
            completion(.success(messages))
        }
    }
    
    func deleteMessage(chat: MChat, completion: @escaping (Result<Void, Error>) -> Void) {
        let reference = waitingChatRef.document(chat.friendId).collection("messages")
        getWaitingChatMessages(chat: chat) { (result) in
            switch result {
            case .success(let messages):
                for message in messages {
                    guard let documentId = message.id else { return }
                    let messageRef = reference.document(documentId)
                    messageRef.delete { (error) in
                        if let error = error {
                            completion(.failure(error.localizedDescription as! Error))
                            return
                        }
                        completion(.success(Void()))
                    }
                }
            case .failure(let error):
                completion(.failure(error.localizedDescription as! Error))
            }
        }
    }
    func changeToActive(chat: MChat, completion: @escaping (Result<Void, Error>) -> Void) {
        getWaitingChatMessages(chat: chat) { (result) in
            switch result {
            case .success(let messages):
                self.deleteWaitingChat(chat: chat) { (result) in
                    switch result {
                    case .success():
                        self.createActiveChat(chat: chat, messages: messages) { (result) in
                            switch result {
                            case .success():
                                completion(.success(Void()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func createActiveChat(chat: MChat, messages: [MMessage], completion: @escaping (Result<Void, Error>) -> Void) {
        let messageRef = self.activeChatRef.document(chat.friendId).collection("messages")
        self.activeChatRef.document(chat.friendId).setData(chat.representation) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            for message in messages {
                messageRef.addDocument(data: message.representation) { (error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                }
                completion(.success(Void()))
            }
        }
        
    }
}


