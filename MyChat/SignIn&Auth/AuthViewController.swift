//
//  AuthViewController.swift
//  MyChat
//
//  Created by Виктор Попов on 27.07.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class  AuthViewController: UIViewController {
    
    let generalMethod = GeneralMethod()
    let signVC: SingUpViewController = SingUpViewController()
    let loginVC: LoginViewController = LoginViewController()
    
    //#MARK: - Create Objects
    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Logo") , contentMode: .scaleAspectFit)
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 40
        stackView.axis = .vertical
//        stackView.contentMode = .scaleAspectFill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let googleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let emailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let loginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white,isShadow: true)
    let emailButton = UIButton(title: "Email", titleColor: .white, backgroundColor: .buttonDark())
    let loginButton = UIButton(title: "Login", titleColor: .buttonRed(), backgroundColor: .white, isShadow: true)
        
    let googleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or sign up with")
    let loginLabel = UILabel(text: "Already onboard?")


    //#MARK: - ViewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        signVC.delegate = self
        loginVC.delegate = self
        
        googleButton.customizedGoogleButton()
        addOnView()
        makeConstraint()
        googleButton.addTarget(self, action: #selector(googleAuthTapped), for: .touchUpInside)
        emailButton.addTarget(self, action: #selector(emailTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }
    
    //#MARK: - Add On View Objects
    private func addOnView() {
        view.addSubview(logoImageView)
        view.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(googleStackView)
        googleStackView.addArrangedSubview(googleLabel)
        googleStackView.addArrangedSubview(googleButton)
        
        mainStackView.addArrangedSubview(emailStackView)
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(emailButton)
        
        mainStackView.addArrangedSubview(loginStackView)
        loginStackView.addArrangedSubview(loginLabel)
        loginStackView.addArrangedSubview(loginButton)
    }
    
    
    //#MARK: - Make Constaimt for Objects
    private func makeConstraint() {
        makeConstraintLogoImage()
        makeConstraintMainStackView()
        generalMethod.makeConstarintStackViewLabelWithButton(label: googleLabel, button: googleButton, stackView: googleStackView)
        generalMethod.makeConstarintStackViewLabelWithButton(label: emailLabel, button: emailButton, stackView: emailStackView)
        generalMethod.makeConstarintStackViewLabelWithButton(label: loginLabel, button: loginButton, stackView: loginStackView)
    }
    
    private func makeConstraintLogoImage() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 116),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func makeConstraintMainStackView() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 80),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }

//    private func makeConstarintStackViewLabelWithButton(label: UILabel, button: UIButton, stackView: UIStackView) {
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
//            label.topAnchor.constraint(equalTo: stackView.topAnchor),
//        ])
//
//        NSLayoutConstraint.activate([
//            button.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
//            button.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
//            button.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
//            button.heightAnchor.constraint(equalToConstant: 60)
//        ])
//
//    }
    
    @objc
    private func emailTapped() {
        present(self.signVC, animated: true, completion: nil)
    }
    
    @objc
    private func loginTapped() {
        present(self.loginVC, animated: true, completion: nil)
    }
    
    @objc private func myGoogleAuthTapped() {
        
    }
    
    
    
    @objc private func googleAuthTapped() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let auth = user?.authentication  else { return }
            let credentional = GoogleAuthProvider.credential(withIDToken: auth.idToken!, accessToken: auth.accessToken)
            
            Auth.auth().signIn(with: credentional) { (result, error) in
                if let error = error {
                    print(error)
                    return
                }
                guard let user = user else {
                    print(error?.localizedDescription as Any)
                    return}
                
                AuthService.shared.googleLogin(user: user, error: error) { (result) in
                    switch result {
                    case .success(let user):
                        FirestoreService.shared.getUserData(muser: user) { (result) in
                            switch result {
                            case .success(let user):
                                self.showAlert(with: "Успешно", and: "Вы авторизованы") {
                                    let muser = MUser(username: user.username, email: user.email, avatarStringURL: user.avatarStringURL, description: user.description, sex: user.sex, id: user.id)
//                                    let mainTabBar = MainTabBarController(currentUser: muser)
//                                    mainTabBar.modalPresentationStyle = .fullScreen
//                                    self.present(mainTabBar, animated: true, completion: nil)
                                    let mainTabBar = MainTabBarController()
                                    mainTabBar.setCurrentUser(user: muser)
                                    mainTabBar.modalPresentationStyle = .fullScreen
                                    self.present(mainTabBar, animated: true, completion: nil)
                                }
                            case .failure(_):
                                self.showAlert(with: "Успешно", and: "Вы зарегистрированны") {
                                    self.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
                                }
                            }
                        }
                    case .failure(let error):
                        self.showAlert(with: "Ошибка", and: error.localizedDescription)
                }

            }
        }
    }
    }
    
     func showAlert(with title: String, and message: String, completion: @escaping () -> Void = { }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
}


extension AuthViewController: AuthNavigationDelegate {
    func toLoginVC() {
        present(LoginViewController(), animated: true, completion: nil)
    }
    
    func toSignUpVC() {
        present(SingUpViewController(), animated: true, completion: nil)
    }
}

