//
//  SingUpViewController.swift
//  MyChat
//
//  Created by Виктор Попов on 28.07.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit

class SingUpViewController: UIViewController {
    
    
    
//    let loginVC: LoginViewController = LoginViewController()
    
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
    let mainLabel = UILabel(text: "Sveik! Hello!")
    
    let emailLabel = UILabel(text: "Email")
    let passworLabel = UILabel(text: "Password")
    let confirmPassworLabel = UILabel(text: "Confirm Password")
    
    let emailTextField = UITextField(font: .avenir20())
    let passwordTextField = UITextField(font: .avenir20())
    let confirmPassworTextField = UITextField(font: .avenir20())
    
    let singUpButton = UIButton(title: "Sing up", titleColor: .white, backgroundColor: .buttonDark())
    
    let footerLabel = UILabel(text: "Already onboard?")
    let loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sing up", for: .normal)
        button.setTitleColor(.buttonRed(), for: .normal)
        button.titleLabel?.font = .avenir20()
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 40
        stackView.axis = .vertical
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
    
    let confirmPasswordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    let singUpStackView: UIStackView = {
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
    
    weak var delegate: AuthNavigationDelegate?
    
    //#MARK: - ViewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        singUpButton.addTarget(self, action: #selector(singUpButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        mainLabel.textAlignment = .center
        mainLabel.font = UIFont.avenir26()
        
        passwordTextField.isSecureTextEntry = true
        confirmPassworTextField.isSecureTextEntry = true
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        addOnView()
        makeConstraint()
    }
    
    //#MARK: - Add On View Objects
    private func addOnView() {
        view.addSubview(mainLabel)
        view.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(emailStackView)
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(emailTextField)
        
        mainStackView.addArrangedSubview(passwordStackView)
        passwordStackView.addArrangedSubview(passworLabel)
        passwordStackView.addArrangedSubview(passwordTextField)
        
        mainStackView.addArrangedSubview(confirmPasswordStackView)
        confirmPasswordStackView.addArrangedSubview(confirmPassworLabel)
        confirmPasswordStackView.addArrangedSubview(confirmPassworTextField)
        
        mainStackView.addArrangedSubview(singUpStackView)
        singUpStackView.addArrangedSubview(singUpButton)
        
        view.addSubview(footerStackView)
        footerStackView.addArrangedSubview(footerLabel)
        footerStackView.addArrangedSubview(loginButton)
    }
    
    //#MARK: - Make Constaint for Objects
    private func makeConstraint() {
        makeConstarintMainLabel()
        makeConstraintMainStackView()
        makeConstaintLabelWithTextField(label: emailLabel, textField: emailTextField, stackView: emailStackView)
        makeConstaintLabelWithTextField(label: passworLabel, textField: passwordTextField, stackView: passwordStackView)
        makeConstaintLabelWithTextField(label: confirmPassworLabel, textField: confirmPassworTextField, stackView: confirmPasswordStackView)
        makeConstaintSingUpButtom()
        makeConstraintFooterStackView()
    }
    
    private func makeConstarintMainLabel() {
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 116),
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
    
    private func makeConstaintSingUpButtom() {
        NSLayoutConstraint.activate([
            singUpButton.leadingAnchor.constraint(equalTo: singUpStackView.leadingAnchor),
            singUpButton.trailingAnchor.constraint(equalTo: singUpStackView.trailingAnchor),
            singUpButton.bottomAnchor.constraint(equalTo: singUpButton.bottomAnchor),
            singUpButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func makeConstraintFooterStackView() {
        NSLayoutConstraint.activate([
            footerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            footerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            footerStackView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 60)
        ])
    }
    
    @objc
    private func singUpButtonTapped() {
        AuthService.shared.register(
            email: emailTextField.text,
            password: passwordTextField.text,
            confirmPassword: passwordTextField.text) { (result) in
                switch result {
                case .success(let user):
                    self.showAlert(with: "Успешно!", and: "Вы зарегистрированны!") {
                        self.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
                    }
                    
                case .failure(let error):
                    self.showAlert(with: "Ошибка!", and: error.localizedDescription)
                }
        }
    }
    
    @objc private func loginButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.toLoginVC()
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
