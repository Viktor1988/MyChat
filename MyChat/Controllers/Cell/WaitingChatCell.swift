//
//  WaitingChatCell.swift
//  MyChat
//
//  Created by Виктор Попов on 02.08.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit

class WaitingChatCell: UICollectionViewCell, SelfConfigureCell {
    func configure<U>(with value: U) where U : Hashable {
        guard let chat: MChat = value as? MChat else { return }
        friendImageView.sd_setImage(with: URL(string: chat.friendAvatarStringUrl), completed: nil)
    }
    
    static var reuseId = "WaitingChatCell"
    
    let friendImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Setup Active Cell
extension WaitingChatCell {
    private func setupConstraints() {
            addSubview(friendImageView)
            
            friendImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                friendImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                friendImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                friendImageView.widthAnchor.constraint(equalToConstant: 78),
                friendImageView.heightAnchor.constraint(equalToConstant: 78)
            ])
        }
}

