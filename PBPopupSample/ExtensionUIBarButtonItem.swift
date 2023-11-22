//
//  ExtensionUIBarButtonItem.swift
//  PBPopupSample
//
//  Created by Oleksandr Balabon on 22.11.2023.
//

import UIKit

extension UIBarButtonItem {
    
    static func popupButtonItem(_ target: Any?, action: Selector, image: UIImage) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(image, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 44).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 52).isActive = true
        
        return menuBarItem
    }
}
