//
//  SecondViewController.swift
//  PBPopupSample
//
//  Created by Oleksandr Balabon on 22.11.2023.
//

import UIKit

class SecondViewController: UIViewController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        if let dissmissImage = UIImage(systemName: "xmark"){
            let closeButton = UIBarButtonItem(image: dissmissImage, style: .plain, target: self, action: #selector(didTapCloseButton))
            closeButton.tintColor = UIColor.systemRed
            navigationItem.leftBarButtonItem = closeButton
        }
    }
    
    @objc private func didTapCloseButton(){
        self.dismiss(animated: true)
    }
}
