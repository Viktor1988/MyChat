//
//  LoginViewController.swift
//  MyChat
//
//  Created by Виктор Попов on 28.07.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class LoginViewController: UIViewController {
    
//    let setupVC: SetupProfileViewController = SetupProfileViewController()
//    let myStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.alignment = .leading
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
    
//    init(){
//        super.init(nibName: nil, bundle: nil)
//        self.modalPresentationStyle = .fullScreen
//        self.modalTransitionStyle = .coverVertical
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    //#MARK: - Create Objects
    let mainLabel = UILabel(text: "Welcome Back!")
    
    let loginWithLabel = UILabel(text: "Login With")
    let orLabel = UILabel(text: "or")
    let emailLabel = UILabel(text: "Email")
    let passworLabel = UILabel(text: "Password")
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white,isShadow: true)
    let loginButton = UIButton(title: "Login", titleColor: .white, backgroundColor: .buttonDark())
    
    let emailTextField = UITextField(font: .avenir20())
    let passwordTextField = UITextField(font: .avenir20())
    
    let footerLabel = UILabel(text: "Already onboard?")
    let singUpButton: UIButton = {
      let button = UIButton(type: .system)
        button.setTitle("Sing up", for: .normal)
        button.setTitleColor(.buttonRed(), for: .normal)
        button.titleLabel?.font = .avenir20()
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    weak var delegate: AuthNavigationDelegate?
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 40
        stackView.axis = .vertical
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
    
    let orStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let emailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let passwordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let loginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let footerStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //#MARK: - ViewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        googleButton.customizedGoogleButton()
        mainLabel.textAlignment = .center
        mainLabel.font = UIFont.avenir26()
        passwordTextField.isSecureTextEntry = true
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        singUpButton.addTarget(self, action: #selector(singUpButtonTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleAuthTapped), for: .touchUpInside)
//        let myView = UIView(label:emailLabel , textField: emailTextField, stackView: myStackView)
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        addOnView()
        makeConstraint()
    }
    //#MARK: - Add On View Objects
    private func addOnView() {
        view.addSubview(mainLabel)
        view.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(googleStackView)
        googleStackView.addArrangedSubview(loginWithLabel)
        googleStackView.addArrangedSubview(googleButton)
        
        mainStackView.addArrangedSubview(orStackView)
        orStackView.addArrangedSubview(orLabel)
        
        mainStackView.addArrangedSubview(emailStackView)
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(emailTextField)
        
        mainStackView.addArrangedSubview(passwordStackView)
        passwordStackView.addArrangedSubview(passworLabel)
        passwordStackView.addArrangedSubview(passwordTextField)
        
        mainStackView.addArrangedSubview(loginStackView)
        loginStackView.addArrangedSubview(loginButton)
        
        view.addSubview(footerStackView)
        footerStackView.addArrangedSubview(footerLabel)
        footerStackView.addArrangedSubview(singUpButton)
        
    }
    
    //#MARK: - Make Constaint for Objects
    private func makeConstraint() {
        makeConstraintMainLabel()
        makeConstraintMainStackView()
        makeConstarintStackViewLabelWithButton(label: loginWithLabel, button: googleButton, stackView: googleStackView)
        makeConstraintOrLabel()
        makeConstaintLabelWithTextField(label: emailLabel, textField: emailTextField, stackView: emailStackView)
        makeConstaintLabelWithTextField(label: passworLabel, textField: passwordTextField, stackView: passwordStackView)
        makeConstaintLoginButtom()
        makeConstraintFooterStackView()
    }
    
    private func makeConstraintMainLabel() {
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 85),
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func makeConstraintMainStackView() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 60),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func makeConstraintOrLabel() {
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            orLabel.topAnchor.constraint(equalTo: orLabel.topAnchor),
            orLabel.leadingAnchor.constraint(equalTo: orStackView.leadingAnchor),
            orLabel.trailingAnchor.constraint(equalTo: orStackView.trailingAnchor)
        ])
    }
    
    private func makeConstaintLoginButtom() {
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: loginStackView.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: loginStackView.trailingAnchor),
            loginButton.bottomAnchor.constraint(equalTo: loginButton.bottomAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func makeConstraintFooterStackView() {
           NSLayoutConstraint.activate([
               footerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
               footerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
               footerStackView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 60)
           ])
       }
    
    private func makeConstarintStackViewLabelWithButton(label: UILabel, button: UIButton, stackView: UIStackView) {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            label.topAnchor.constraint(equalTo: stackView.topAnchor),
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            button.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            button.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func makeConstaintLabelWithTextField(label: UILabel, textField: UITextField, stackView: UIStackView) {
           NSLayoutConstraint.activate([
               label.topAnchor.constraint(equalTo: stackView.topAnchor),
               label.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
           ])
           NSLayoutConstraint.activate([
               textField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
               textField.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
               textField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
           ])
       }
    
    @objc
    private func loginButtonTapped() {
        AuthService.shared.login(
            email: emailTextField.text!,
            password: passwordTextField.text!) { (result) in
                switch result {
                case .success(let user):
                    self.showAlert(with: "Успешно!", and: "Вы авторизованы!") {
                        FirestoreService.shared.getUserData(muser: user) { (result) in
                            switch result {
                                
                            case .success(let muser):
                                let mainTabBar = MainTabBarController(currentUser: muser)
                                mainTabBar.modalPresentationStyle = .fullScreen
                                self.present(mainTabBar, animated: true, completion: nil)
//                                let mainTabBarVC = MainTabBarController()
//                                mainTabBarVC.setCurrentUser(user: muser)
//                                self.present(mainTabBarVC, animated: true, completion: nil)
                            case .failure(_):
                                self.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
                            }
                        }
                        
                    }
                case .failure(let error):
                    self.showAlert(with: "Ошибка!", and: error.localizedDescription)
                }
        }
    }
    
    @objc private func singUpButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.toSignUpVC()
        }
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
                                    let mainTabBar = MainTabBarController(currentUser: muser)
                                    mainTabBar.modalPresentationStyle = .fullScreen
                                    self.present(mainTabBar, animated: true, completion: nil)
//                                    let mainTabBar = MainTabBarController()
//                                    mainTabBar.setCurrentUser(user: muser)
//                                    mainTabBar.modalPresentationStyle = .fullScreen
//                                    self.present(mainTabBar, animated: true, completion: nil)
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
    
    
    private func showAlert(with title: String, and message: String, completion: @escaping () -> Void = { }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
}
