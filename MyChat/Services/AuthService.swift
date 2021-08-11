//
//  AuthService.swift
//  MyChat
//
//  Created by Виктор Попов on 03.08.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class AuthService{
    
    static let shared = AuthService()
    private let auth = Auth.auth()
    
    func register(email: String?, password: String?, confirmPassword: String?, completion: @escaping (Result<User, Error>) -> Void) {
        
        guard Validators.isFilled(email: email, password: password, confirmPassword: confirmPassword) else {
            completion(.failure(AuthError.notFilled))
            return
        }
        
        guard password!.lowercased() == confirmPassword!.lowercased() else {
            completion(.failure(AuthError.passwordNotMatched))
            return
        }
        
        guard Validators.isSimpleEmail(email!) else {
            completion(.failure(AuthError.invalidateEmail))
            return
        }
        
        auth.createUser(withEmail: email!, password: password!) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    
    func login(email:String?, password: String?,completion: @escaping(Result<User, Error>) -> Void) {
        
        guard let email = email, let password = password else {
            completion(.failure(AuthError.notFilled))
            return
        }

        auth.signIn(withEmail: email, password: password) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return }
            completion(.success(result.user))
        }
    }
    
    func googleLogin(user: GIDGoogleUser?, error: Error?,completion: @escaping(Result<User, Error>) -> Void  ) {
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let auth = user?.authentication  else { return }
        let credentional = GoogleAuthProvider.credential(withIDToken: auth.idToken!, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credentional) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return }
            completion(.success(result.user))
        }
    }
}


