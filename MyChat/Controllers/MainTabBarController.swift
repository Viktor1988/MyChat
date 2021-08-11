//
//  MainTabBarController.swift
//  MyChat
//
//  Created by Виктор Попов on 30.07.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit

protocol MainTabBarControllerLogic {
    func setCurrentUser(user: MUser)
}

class MainTabBarController: UITabBarController {
    private let currentUser: MUser
       
       init(currentUser: MUser = MUser(username: "frfer",
                                       email: "fr",
                                       avatarStringURL: "fer",
                                       description: "fre",
                                       sex: "ewr",
                                       id: "fregtr")) {
           self.currentUser = currentUser
           super.init(nibName: nil, bundle: nil)
       }
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           let listViewController = ListViewController(currentUser: currentUser)
           let peopleViewController = PeopleViewController(currentUser: currentUser)
           
           tabBar.tintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
           let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
           let convImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfig)!
           let peopleImage = UIImage(systemName: "person.2", withConfiguration: boldConfig)!
           
           viewControllers = [
               generateNavigationController(rootViewController: peopleViewController, title: "People", image: peopleImage),
               generateNavigationController(rootViewController: listViewController, title: "Conversations", image: convImage)
           ]
       }
       
       private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
           let navigationVC = UINavigationController(rootViewController: rootViewController)
           navigationVC.tabBarItem.title = title
           navigationVC.tabBarItem.image = image
           return navigationVC
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
}
    
//{
//     var currentUser: MUser?
//
//     let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
//
//    init(currentUser: MUser){
//        self.currentUser = currentUser
//        super.init(nibName: nil, bundle: nil)
//        self.modalPresentationStyle = .fullScreen
//        self.modalTransitionStyle = .crossDissolve
//    }
//
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        self.modalPresentationStyle = .fullScreen
//        self.modalTransitionStyle = .crossDissolve
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        view.backgroundColor = .red
//        if let currentUser = self.currentUser {
//            let peopleViewController = PeopleViewController(currentUser: currentUser)
//            let listViewController = ListViewController(currentUser: currentUser)
//            let peopleImage = UIImage(systemName: "person.2", withConfiguration: boldConfig)!
//            let listImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfig)!
//            viewControllers = [
//                generationNavigationController(rootController: listViewController, title: "Conversation", image: listImage),
//                generationNavigationController(rootController: peopleViewController, title: "People", image: peopleImage)
//            ]
//        }
//
//    }
//
//    private func generationNavigationController(rootController: UIViewController, title: String, image: UIImage) -> UIViewController {
//        let navigationVC = UINavigationController(rootViewController: rootController)
//        navigationVC.tabBarItem.title = title
//        navigationVC.tabBarItem.image = image
//        tabBar.tintColor = #colorLiteral(red: 0.5568627451, green: 0.3529411765, blue: 0.5607843137, alpha: 1)
//        return navigationVC
//    }
//}

//extension MainTabBarController: MainTabBarControllerLogic {
//    func setCurrentUser(user: MUser) {
//        self.currentUser = user
//    }
//}
