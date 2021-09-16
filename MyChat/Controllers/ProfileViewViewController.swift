//
//  ProfileViewViewController.swift
//  MyChat
//
//  Created by Виктор Попов on 03.08.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewViewController: UIViewController {

    let container = UIView()
    let imageView = UIImageView(image: #imageLiteral(resourceName: "human2"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Viktor Popov", font: .systemFont(ofSize: 26, weight: .light))
    let aboutMeLabel = UILabel(text: "I like travaling for World", font: .systemFont(ofSize: 16, weight: .light))
    let textField = InsertableTextField()
    //    let textField: UITextField = {
//       let textField = UITextField()
//        textField.borderStyle = .roundedRect
//        return textField
//    }()
        
    
    private let user : MUser
    init(user: MUser) {
        self.user = user
        self.nameLabel.text = user.username
        self.aboutMeLabel.text = user.description
        self.imageView.sd_setImage(with: URL(string: user.avatarStringURL), completed: nil)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
            container.layer.cornerRadius = 32
            container.clipsToBounds = true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        container.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
        addOnView()
        makeConstraint()
        
        if let button = textField.rightView as? UIButton {
            button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        }
    }
    
    @objc private func sendMessage() {
        guard let message = textField.text, textField.text != "" else { return }
        print("your message: \(String(describing: textField.text))\n sent!")
        textField.text = ""
        dismiss(animated: true) {
            FirestoreService.shared.crateWaitingChat(message: message, receiver: self.user) { (result) in
                switch result {
                    
                case .success():
                    print("Success, Ваше сообщение для \(self.user.username) отправлено")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func addOnView() {
        view.addSubview(imageView)
        view.addSubview(container)
        container.addSubview(nameLabel)
        container.addSubview(aboutMeLabel)
        container.addSubview(textField)
    }
    
    private func makeConstraint() {
        makeConstraintContainer()
        makeConstraintImageView()
        makeConstraintNameLabel()
        makeConstraintAboutMeLabel()
        makeConstraintTextField()
    }
    
    private func makeConstraintImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
    
    private func makeConstraintContainer() {
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func makeConstraintNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ])
    }
    
    private func makeConstraintAboutMeLabel() {
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            aboutMeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            aboutMeLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            aboutMeLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ])
    }
    
    private func makeConstraintTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
}
