//
//  ActiveChatCell.swift
//  MyChat
//
//  Created by Виктор Попов on 02.08.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit
class  ActiveChatCell: UICollectionViewCell, SelfConfigureCell {
    static var reuseId: String = "ActiveChatCell"
    
    let friendImageView = UIImageView()
    let friendName = UILabel(text: "User Name",font: .laoSangamMN20())
    let lastMessage = UILabel(text: "How are You, my dear favorite friends ?", font: .laoSangamMN18())
    let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1), endColor: #colorLiteral(red: 0.4784313725, green: 0.6980392157, blue: 0.9215686275, alpha: 1))
    
    func configure<U>(with value: U) where U : Hashable  {
        guard let chat: MChat = value as? MChat else { return }
        friendImageView.sd_setImage(with: URL(string: chat.friendAvatarStringUrl), completed: nil)
        friendName.text = chat.friendUsername
        lastMessage.text = chat.lastMessageContent
    }

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
extension ActiveChatCell {
    private func setupConstraints() {
            addSubview(friendImageView)
            addSubview(gradientView)
            addSubview(friendName)
            addSubview(lastMessage)
            
            friendImageView.translatesAutoresizingMaskIntoConstraints = false
            friendName.translatesAutoresizingMaskIntoConstraints = false
            lastMessage.translatesAutoresizingMaskIntoConstraints = false
            gradientView.translatesAutoresizingMaskIntoConstraints = false
//            friendImageView.backgroundColor = .blue
//            gradientView.backgroundColor = .black
//            friendName.backgroundColor = .green
//            lastMessage.backgroundColor = .systemPink
            
            NSLayoutConstraint.activate([
                friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                friendImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                friendImageView.widthAnchor.constraint(equalToConstant: 78),
                friendImageView.heightAnchor.constraint(equalToConstant: 78)
            ])
            
            NSLayoutConstraint.activate([
                friendName.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
                friendName.topAnchor.constraint(equalTo: friendImageView.topAnchor, constant: 16),
                friendName.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: -16)
            ])
            
            NSLayoutConstraint.activate([
                lastMessage.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
                lastMessage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
                lastMessage.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: -16)
            ])
            
            NSLayoutConstraint.activate([
                gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                gradientView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                gradientView.widthAnchor.constraint(equalToConstant: 8),
                gradientView.heightAnchor.constraint(equalToConstant: 78)
            ])
        }
}
