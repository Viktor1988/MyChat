//
//  ChatRequestViewController.swift
//  MyChat
//
//  Created by Виктор Попов on 03.08.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit

class ChatRequestViewController: UIViewController {

    let container = UIView()
    let imageView = UIImageView(image: #imageLiteral(resourceName: "human2"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Viktor Popov", font: .systemFont(ofSize: 26, weight: .light))
    let aboutMeLabel = UILabel(text: "I like travaling for World", font: .systemFont(ofSize: 16, weight: .light))
    let acсeptButton = UIButton(title: "ACCEPT", titleColor: .white, backgroundColor: #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), font: .avenir20(), isShadow: true, cornerRadius: 15)
    let denyButton = UIButton(title: "Deny", titleColor: .red, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), font: .avenir20(), isShadow: false, cornerRadius: 15)
    
    weak var delegate: WaitingChatsNavigation?
    
    private var chat: MChat
    init(chat: MChat) {
        self.chat = chat
        nameLabel.text = chat.friendUsername
        aboutMeLabel.text = ""
        imageView.sd_setImage(with: URL(string: chat.friendAvatarStringUrl), completed: nil)
        super.init(nibName: nil, bundle: nil )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        container.layer.cornerRadius = 32
        container.clipsToBounds = true
        container.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
        
        denyButton.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        denyButton.layer.borderWidth = 1.2
        
        denyButton.addTarget(self, action: #selector(denyButtonTapped), for: .touchUpInside)
        acсeptButton.addTarget(self, action: #selector(acсeptButtonTapped), for: .touchUpInside)
        
        addOnView()
        makeConstraint()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        acсeptButton.applyGradients(cornerRarius: 10)
    }
    
    private func addOnView() {
        view.addSubview(imageView)
        view.addSubview(container)
        container.addSubview(nameLabel)
        container.addSubview(aboutMeLabel)
        container.addSubview(acсeptButton)
        container.addSubview(denyButton)
        
    }
    
    private func makeConstraint() {
        makeConstraintImageView()
        makeConstraintContainer()
        makeConstraintNameLabel()
        makeConstraintAboutMeLabel()
        makeConstraintAcceptButton()
        makeConstraintDenyButton()
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
    
    private func makeConstraintAcceptButton() {
        acсeptButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            acсeptButton.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 24),
            acсeptButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            acсeptButton.widthAnchor.constraint(equalToConstant: 166),
            acсeptButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func makeConstraintDenyButton() {
        denyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            denyButton.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 24),
            denyButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            denyButton.widthAnchor.constraint(equalToConstant: 166),
            denyButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    
    @objc
    private func denyButtonTapped() {
        self.dismiss(animated: true) {
            self.delegate?.removeWaitingChat(chat: self.chat)
        }
    }
    
    @objc
    private func acсeptButtonTapped() {
        dismiss(animated: true){
        self.delegate?.chatToActive(chat: self.chat)
        }
    }

}
