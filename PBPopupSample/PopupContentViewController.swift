//
//  PopupContentViewController.swift
//  PBPopupSample
//
//  Created by Oleksandr Balabon on 22.12.2022.
//

import UIKit
import PBPopupController

class PopupContentViewController: UIViewController {
    
    // A flag to store the current status bar style
    private var isDarkContentBackground = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGray
    }
    
    // Overriding the preferredStatusBarStyle to return the current status bar style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if isDarkContentBackground {
            return .darkContent
        } else {
            return .lightContent
        }
    }
}

// MARK: - Set the status bar style to light/dark content
extension PopupContentViewController {
    
    private func statusBarEnterLightBackground() {
        isDarkContentBackground = false
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func statusBarEnterDarkBackground() {
        isDarkContentBackground = true
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // Function to update the status bar style based on the input style
    func updatePopupContentStatusBar(style: UIStatusBarStyle) {
        switch style {
        case .default:
            break
        case .lightContent:
            statusBarEnterLightBackground()
        case .darkContent:
            statusBarEnterDarkBackground()
        @unknown default:
            break
        }
    }
}
