//
//  ListViewController.swift
//  MyChat
//
//  Created by Виктор Попов on 30.07.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ListViewController: UIViewController {
    
    var activeChats = [MChat]()
    var waitingChats = [MChat]()
    
    private var waitingChatsListener: ListenerRegistration?
    private var activeChatsListener: ListenerRegistration?
    
    enum Section: Int, CaseIterable {
        case  waitingChats, activeChats
        
        func description() -> String {
            switch self {
            case .waitingChats:
                return "Waiting chats"
            case .activeChats:
                return "Active chats"
            }
        }
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, MChat>?
    var collectionView: UICollectionView!
    
    private let currentUser: MUser
       
       init(currentUser: MUser) {
           self.currentUser = currentUser
           super.init(nibName: nil, bundle: nil)
           title = currentUser.username
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        waitingChatsListener?.remove()
        activeChatsListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupCollectionView()
        createDataSource()
        reloadData()
        
        waitingChatsListener = ListenerService.shared.waitingChatsObserve(chats: waitingChats, completion: { (result) in
            switch result {
            case .success(let chats):
                if self.waitingChats != [], self.waitingChats.count <= chats.count {
                    let chatRequestVC = ChatRequestViewController(chat: chats.last!)
                    chatRequestVC.delegate = self
                    self.present(chatRequestVC, animated: true, completion: nil)
                }
                self.waitingChats = chats
                self.reloadData()
            case .failure(let error):
                self.showAlert(with: "Ошибка!", and: error.localizedDescription)
            }
        })
        
        activeChatsListener = ListenerService.shared.activeChatsObserve(chats: activeChats, completion: { (result) in
            switch result {
            case .success(let chats):
                self.activeChats = chats
                self.reloadData()
            case .failure(let error):
                self.showAlert(with: "Ошибка!", and: error.localizedDescription)
            }
        })
    }
    
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = .mainWhite()
        navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite()
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
        collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseId)
        collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseId)
        
        collectionView.delegate = self
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MChat>()
        
        snapshot.appendSections([.waitingChats, .activeChats])
        
        snapshot.appendItems(waitingChats, toSection: .waitingChats)
        snapshot.appendItems(activeChats, toSection: .activeChats)

        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Data Source
extension ListViewController {
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MChat>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, chat) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            
            switch section {
            case .activeChats:
                return self.configure(collectionView: collectionView, cellType: ActiveChatCell.self, with: chat, for: indexPath)
            case .waitingChats:
                 return self.configure(collectionView: collectionView, cellType: WaitingChatCell.self, with: chat, for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("Can not create new section header") }
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section kind") }
            sectionHeader.configurate(text: section.description(),
                                    font: .laoSangamMN20(),
                                    color: #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1))
            return sectionHeader
        }
    }
}

// MARK: - Setup layout
extension ListViewController {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (senctionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: senctionIndex) else {
                fatalError("Unknown section kind")
            }
        
            switch section {
            case .activeChats:
                return self.createActiveChats()
            case .waitingChats:
                return self.createWaitingChats()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private func createWaitingChats() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(88),
                                               heightDimension: .absolute(88))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 20, bottom: 0, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createActiveChats() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(78))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 20, bottom: 0, trailing: 20)
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        
        return sectionHeader
    }
}

// MARK: - UICollectionViewDelegate
extension ListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let chat = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        guard let section = Section(rawValue: indexPath.section) else { return }
        let muser = MUser(username: chat.friendUsername, email: "test@mail.ru", avatarStringURL: chat.friendAvatarStringUrl, description: "nil", sex: "nil", id: chat.friendId)
        switch section {
        case .waitingChats:
            let chatRequestVC = ChatRequestViewController(chat: chat)
            chatRequestVC.delegate = self
            self.present(chatRequestVC, animated: true, completion: nil)
        case .activeChats:
            print(indexPath)
            let profileVC = ProfileViewViewController(user: muser)
            self.present(profileVC, animated: true, completion: nil)
//            let chatsVC = ChatsViewController(user: currentUser, chat: chat)
//            navigationController?.pushViewController(chatsVC, animated: true)
        }
    }
}

// MARK: - WaitingChatsNavigation
extension ListViewController: WaitingChatsNavigation {
    func chatToActive(chat: MChat) {
            FirestoreService.shared.changeToActive(chat: chat) { (result) in
                switch result {
    
                case .success():
                    self.showAlert(with: "Успешно", and: "Приятного общения с \(chat.friendUsername).")
                case .failure(let error):
                    self.showAlert(with: "Ошибка", and: error.localizedDescription  )
                }
            }
        }
    
    func removeWaitingChat(chat: MChat) {
        FirestoreService.shared.deleteWaitingChat(chat: chat) { (result) in
            switch result {
            case .success:
                self.showAlert(with: "Успешно!", and: "Чат с \(chat.friendUsername) был удален")
            case .failure(let error):
                self.showAlert(with: "Ошибка!", and: error.localizedDescription)
            }
        }
    }
    
    func changeToActive(chat: MChat) {
        print(#function)
        FirestoreService.shared.changeToActive(chat: chat) { (result) in
            switch result {
            case .success:
                self.showAlert(with: "Успешно!", and: "Приятного общения с \(chat.friendUsername).") 
            case .failure(let error):
                self.showAlert(with: "Ошибка!", and: error.localizedDescription)
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

// MARK: - UISearchBarDelegate
extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}


//class ListViewController: UIViewController {
////Удаляем, потому используем json-файлы с нужными данными
////    let activeChats: [MChat] = [
////        MChat(userName: "Alex", userImage: UIImage(named: "human1")!, lastMessage: "How are you ?"),
////        MChat(userName: "Poll", userImage: UIImage(named: "human2")!, lastMessage: "How are you ?"),
////        MChat(userName: "Tom", userImage: UIImage(named: "human3")!, lastMessage: "How are you ?"),
////        MChat(userName: "Mila", userImage: UIImage(named: "human4")!, lastMessage: "How are you ?")
////    ]
//    //MARK: - Setup objects
//
//    var activeChats = [MChat]()//Bundle.main.decode([MChat].self, from: "activeChats.json") - для тестирования нужны были
//    var waitingChats = [MChat]()//Bundle.main.decode([MChat].self, from: "waitingChats.json")
//    private var waitingChatsListener: ListenerRegistration?
//    private var activeChatsListener: ListenerRegistration?
//
//    enum Section: Int, CaseIterable {
//        case  waitingChats, activeChats
//
//        func description() -> String {
//            switch self {
//            case .waitingChats:
//                return "Waiting chats"
//            case .activeChats:
//                return "Active chats"
//            }
//        }
//    }
//
//    var collectionView: UICollectionView!
//    var dataSource: UICollectionViewDiffableDataSource<Section, MChat>?
//
//    private let currentUser: MUser
//    init(currentUser: MUser){
//        self.currentUser = currentUser
//        super.init(nibName: nil, bundle: nil)
//        self.modalPresentationStyle = .fullScreen
//        self.modalTransitionStyle = .flipHorizontal
//        self.title = currentUser.username
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    //MARK: - ViewDidload
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .mainWhite()
//        setupCollectionView()
//        setUpSearchBar()
//        createDataSource()
//        reloadData()
//
//        waitingChatsListener = ListenerService.shared.waitingChatsObserve(chats: waitingChats , completion: { (result) in
//            switch result {
//
//            case .success(let chats):
//                //Подумать над условием, Вариант Пархоменко не работает правильно, через жопу только
//                if self.waitingChats != [], self.waitingChats.count <= chats.count {
//                    let requestVC = ChatRequestViewController(chat: chats.last!)
//                    requestVC.delegate = self
//                    self.present(requestVC, animated: true, completion: nil)
//                }
//                self.waitingChats = chats
//                self.reloadData()
//            case .failure(let error):
//                self.showAlert(with: "Ошибка", and: error.localizedDescription)
//
//            }
//        })
//
//        activeChatsListener = ListenerService.shared.activeChatsObserve(chats: activeChats, completion: { (result) in
//            switch result {
//            case .success(let chats):
//                self.activeChats = chats
//                self.reloadData()
//                self.dismiss(animated: true, completion: nil)
//            case .failure(let error):
//                self.showAlert(with: "Ошибка", and: error.localizedDescription)
//            }
//        })
//
//    }
//
//    deinit {
//        waitingChatsListener?.remove()
//        activeChatsListener?.remove()
//    }
//
//    private func setupCollectionView() {
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionLayout())
//        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        collectionView.backgroundColor = .mainWhite()
//        view.addSubview(collectionView)
//        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
//        collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseId)
//        collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseId)
//        collectionView.delegate = self
//        //Удаляем, потому переделываем через CompositionLayout
//        //        collectionView.delegate = self
//        //        collectionView.dataSource = self
//    }
//
//
//
//    private func reloadData() {
//        var snapshot = NSDiffableDataSourceSnapshot<Section, MChat>()
//        snapshot.appendSections([.waitingChats,.activeChats])
//        snapshot.appendItems(waitingChats, toSection: .waitingChats)
//        snapshot.appendItems(activeChats, toSection: .activeChats)
//        dataSource?.apply(snapshot,animatingDifferences: true)
//    }
//
//    private func showAlert(with title: String, and message: String, completion: @escaping () -> Void = { }) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
//            completion()
//        }
//        alertController.addAction(okAction)
//        present(alertController, animated: true, completion: nil)
//
//    }
//}
//
////Удаляем, потому переделываем через CompositionLayout
////extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
////    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        return 5
////    }
////
////    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath)
////        cell.backgroundColor = .red
////        return cell
////    }
////}
//
////MARK: - SearchBar Delegate
//extension ListViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print(searchText)
//    }
//}
//
////MARK: - Setup Layout
//extension ListViewController {
//    private func createCompositionLayout() -> UICollectionViewLayout {
//        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
//
//            guard let section = Section(rawValue: sectionIndex) else { fatalError("Unknown section kind")}
//            switch section {
//
//            case .waitingChats:
//                return self.createWaitingChats()
//            case .activeChats:
//                return self.createActiveChats()
//            }
//        }
//        let config = UICollectionViewCompositionalLayoutConfiguration()
//        config.interSectionSpacing = 20
//        layout.configuration = config
//        return layout
//    }
//
//    private func createWaitingChats() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(88 ), heightDimension: .absolute(88))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = 16
//        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)
//        section.orthogonalScrollingBehavior = .continuous
//
//        section.boundarySupplementaryItems = [createSectionHeader()]
//        return section
//    }
//
//    private func createActiveChats() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
//                                              heightDimension: .fractionalHeight(1))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
//                                               heightDimension: .absolute(78))
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = 8
//        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 20, bottom: 0, trailing: 20)
//
//        let sectionHeader = createSectionHeader()
//        section.boundarySupplementaryItems = [sectionHeader]
//        return section
//    }
//}
//
////:MARK DataSource
//extension ListViewController {
//
//    private func createDataSource() {
//        dataSource = UICollectionViewDiffableDataSource<Section, MChat>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, chat)
//            -> UICollectionViewCell? in
//            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section kind")}
//            switch section {
//            case .activeChats:
//                return self.configure(collectionView: collectionView, cellType: ActiveChatCell.self, with: chat, for: indexPath)
//            case .waitingChats:
//                 return self.configure(collectionView: collectionView, cellType: WaitingChatCell.self, with: chat, for: indexPath)
//            }
//        })
//
//        dataSource?.supplementaryViewProvider = {
//            collectionView, kind, indexPath in
//            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("Error header Section")}
//            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section kind")}
//            sectionHeader.configurate(text: section.description(), font: .laoSangamMN20(), color: #colorLiteral(red: 0.5725490196, green: 0.5725490196, blue: 0.5725490196, alpha: 1))
//            return sectionHeader
//
//        }
//    }
//
//    private func setUpSearchBar() {
//        navigationController?.navigationBar.barTintColor = .mainWhite()
//        navigationController?.navigationBar.shadowImage = UIImage()
//        let searchController = UISearchController(searchResultsController: nil)
//        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
//        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.delegate = self
//    }
//
//    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
//        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
//                                                       heightDimension: .estimated(1))
//        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
//                                                                        elementKind: UICollectionView.elementKindSectionHeader,
//                                                                        alignment: .top)
//        return sectionHeader
//    }
//}
//
////MARK: UICollectionViewDelegate
//extension ListViewController:  UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let chat = self.dataSource!.itemIdentifier(for: indexPath) else { return }
//        guard let section = Section(rawValue: indexPath.section) else { return }
//        switch  section {
//
//        case .waitingChats:
//            let chatRequestVC = ChatRequestViewController(chat: chat)
//            chatRequestVC.delegate = self
//            self.present(chatRequestVC, animated: true, completion: nil)
//        case .activeChats:
//            print(indexPath)
////            let chatsVC = ChatsViewController(user: currentUser, mchat: chat)
////            navigationController?.pushViewController(chatsVC, animated: true)
//        }
//
//    }
//}
//
//extension ListViewController: WaitingChatsNavigation {
//    func removeWaitingChat(chat: MChat) {
//        FirestoreService.shared.deleteWaitingChat(chat: chat) { (result) in
//            switch result {
//
//            case .success():
//                self.showAlert(with: "Успешно", and: "Чат с \(chat.friendUsername) был удален")
//            case .failure(let error):
//                self.showAlert(with: "Ошибка", and: error.localizedDescription)
//            }
//        }
//    }
//
//    func chatToActive(chat: MChat) {
//        FirestoreService.shared.changeToActive(chat: chat) { (result) in
//            switch result {
//
//            case .success():
//                self.showAlert(with: "Успешно", and: "Приятного общения с \(chat.friendUsername).")
//            case .failure(let error):
//                self.showAlert(with: "Ошибка", and: error.localizedDescription  )
//            }
//        }
//    }
//}
//
////удаляем, так как он был исползован для примера
////extension ListViewController: UICollectionViewDelegateFlowLayout {
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        return CGSize.init(width: view.frame.width, height: 64)
////    }
////}
