//
//  StorageService.swift
//  MyChat
//
//  Created by Виктор Попов on 05.08.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth


class StorageService {
    
    static let shared = StorageService()
    
    let storageRef = Storage.storage().reference()
    
    private var avatarsRef: StorageReference {
        return storageRef.child("avatars")
    }
    
    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    
    func upload(photo:UIImage, completion: @escaping (Result<URL,Error>) -> Void) {
        guard let scaleImage =  photo.scaledToSafeUploadSize, let imageData = scaleImage.jpegData(compressionQuality: 0.4) else {
            return
        }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        avatarsRef.child(currentUserId).putData(imageData, metadata: metaData) { (metaData, error) in
            guard let _ = metaData else {
                completion(.failure(error!))
                return
            }
            self.avatarsRef.child(self.currentUserId).downloadURL { (url, error) in
                guard let downLoadUrl = url else { completion(.failure(error!))
                    return
                }
                completion(.success(downLoadUrl))
            }
        }
        
    }
}
