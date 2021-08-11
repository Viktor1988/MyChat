//
//  AddPhotoView.swift
//  MyChat
//
//  Created by Виктор Попов on 29.07.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit

class AddPhotoView: UIView {

    var circleImageView : UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "avatar")
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    var plussButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let myImage = #imageLiteral(resourceName: "plus")
        button.setImage(myImage, for: .normal)
        button.tintColor = .buttonDark()
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(circleImageView)
        self.addSubview(plussButton)
        makeConstraint()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleImageView.layer.cornerRadius = circleImageView.frame.width / 2
        circleImageView.layer.masksToBounds = true
    }
    
    private func makeConstraint() {
        NSLayoutConstraint.activate([
            circleImageView.topAnchor.constraint(equalTo: self.topAnchor),
            circleImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            circleImageView.heightAnchor.constraint(equalToConstant: 100),
            circleImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            plussButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            plussButton.leadingAnchor.constraint(equalTo: circleImageView.trailingAnchor, constant: 16),
            plussButton.heightAnchor.constraint(equalToConstant: 30),
            plussButton.widthAnchor.constraint(equalToConstant: 30)
            
        ])
        self.bottomAnchor.constraint(equalTo: circleImageView.bottomAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: plussButton.trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
