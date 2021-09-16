//
//  SetupProfileViewController.swift
//  MyChat
//
//  Created by Виктор Попов on 29.07.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage


class SetupProfileViewController: UIViewController {
    
    private let currentUser: User
    
    init(currentUser: User){
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
        self.modalTransitionStyle = .crossDissolve
        if let userName = self.currentUser.displayName {
            fullNameTextField.text = userName
        }
        
        if let photoUrl = currentUser.photoURL  {
            avatarImage.circleImageView.sd_setImage(with: photoUrl, completed: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    let tabBarVC: MainTabBarController = MainTabBarController()
    
    //#MARK: - Create Objects
    let mainLabel = UILabel(text: "Set up profile")
    let avatarImage = AddPhotoView()
    
    let fullNameLabel = UILabel(text: "Full Name")
    let aboutMeLabel = UILabel(text: "About me")
    let fullNameTextField = UITextField(font: .avenir20())
    let aboutMeTextField = UITextField(font: .avenir20())
    
    let sexLabel = UILabel(text: "Sex")
    let sexSegmentedControl = UISegmentedControl(first: "Male", second: "Fmale")
    
    let goToChatsButton = UIButton(title: "Go to chats", titleColor: .white, backgroundColor: .buttonDark())
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 40
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let avatarImageViewStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let fullNameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let aboutMeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let segmentedControlStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let goToChatsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //#MARK: - ViewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        mainLabel.textAlignment = .center
        mainLabel.font = UIFont.avenir26()
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .white
        addOnView()
        makeConstraint()
        avatarImage.plussButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        goToChatsButton.addTarget(self, action: #selector(goToChatsButtonTapped), for: .touchUpInside)
    }
    
    //#MARK: - Add On View Objects
    private func addOnView() {
        view.addSubview(mainLabel)
        
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(avatarImageViewStackView)
        avatarImageViewStackView.addArrangedSubview(avatarImage)
        
        mainStackView.addArrangedSubview(fullNameStackView)
        fullNameStackView.addArrangedSubview(fullNameLabel)
        fullNameStackView.addArrangedSubview(fullNameTextField)
        
        mainStackView.addArrangedSubview(aboutMeStackView)
        aboutMeStackView.addArrangedSubview(aboutMeLabel)
        aboutMeStackView.addArrangedSubview(aboutMeTextField)
        
        mainStackView.addArrangedSubview(segmentedControlStackView)
        segmentedControlStackView.addArrangedSubview(sexLabel)
        segmentedControlStackView.addArrangedSubview(sexSegmentedControl)
        
        mainStackView.addArrangedSubview(goToChatsStackView)
        goToChatsStackView.addArrangedSubview(goToChatsButton)
    
    }
    
    //#MARK: - Make Constaint for Objects
    private func makeConstraint() {
        makeConstraintMainLabel()
        makeConstraintMainStackView()
        makeConstaintLabelWithTextField(label: fullNameLabel, textField: fullNameTextField , stackView: fullNameStackView)
        makeConstaintLabelWithTextField(label: aboutMeLabel, textField: aboutMeTextField , stackView: aboutMeStackView)
        makeConstarintSegmentElements(label: sexLabel, segmentControl: sexSegmentedControl, stackView: segmentedControlStackView)
        makeConstaintGoToChatButtom()
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
            mainStackView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 40),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func makeConstaintGoToChatButtom() {
        NSLayoutConstraint.activate([
            goToChatsButton.leadingAnchor.constraint(equalTo: goToChatsStackView.leadingAnchor),
            goToChatsButton.trailingAnchor.constraint(equalTo: goToChatsStackView.trailingAnchor),
            goToChatsButton.bottomAnchor.constraint(equalTo: goToChatsStackView.bottomAnchor),
            goToChatsButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    private func goToChatsButtonTapped() {
        
        FirestoreService.shared.saveProfileWith(
            id: currentUser.uid,
            email: currentUser.email!,
            username: fullNameTextField.text,
            avatarImage: avatarImage.circleImageView.image,
            description: aboutMeTextField.text,
            sex: sexSegmentedControl.titleForSegment(at: sexSegmentedControl.selectedSegmentIndex)) { (result) in
                switch result {
                    
                case .success(let muser):
                    self.showAlert(with: "Успешно!", and: "Данные сохранены!", completion: {
//                        let mainTabBar = MainTabBarController(currentUser: muser)
//                        mainTabBar.modalPresentationStyle = .fullScreen
//                        self.present(mainTabBar, animated: true, completion: nil)
                        let mainTabBarVC = MainTabBarController()
                        mainTabBarVC.setCurrentUser(user: muser)
                        self.present(mainTabBarVC, animated: true, completion: nil)
                    })
                    // present(MainTabBarController(), animated: true, completion: nil)
                case .failure(let error):
                    self.showAlert(with: "Ошибка!", and: error.localizedDescription)
                }
        }
       
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
    
    private func makeConstarintSegmentElements(label: UILabel, segmentControl: UISegmentedControl, stackView: UIStackView) {

        NSLayoutConstraint.activate([
        label.topAnchor.constraint(equalTo: stackView.topAnchor),
        label.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            segmentControl.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            segmentControl.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
    
    @objc
    private func plusButtonTapped() {
    let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
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

extension SetupProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] else { return }
        avatarImage.circleImageView.image = (image as! UIImage)
    }
}
