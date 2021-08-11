//
//  UIViewController + Extension.swift
//  MyChat
//
//  Created by Виктор Попов on 03.08.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit


extension UIViewController {
    
    func configure<T: SelfConfigureCell, U: Hashable>(collectionView: UICollectionView, cellType: T.Type, with value: U, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else { fatalError("Unable to dequeue \(cellType)") }
        cell.configure(with: value)
        return cell
    }
    
}
