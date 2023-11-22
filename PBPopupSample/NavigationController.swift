//
//  NavigationController.swift
//  PBPopupSample
//
//  Created by Oleksandr Balabon on 22.12.2022.
//

import UIKit

class NavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setupNavigationBarBackground()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNavigationBarBackground()
    }

    private func setupNavigationBarBackground() {
        if #available(iOS 13, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithDefaultBackground()

            let appearance = UINavigationBar.appearance()
            appearance.scrollEdgeAppearance = navBarAppearance
            appearance.compactAppearance = navBarAppearance
            appearance.standardAppearance = navBarAppearance
            if #available(iOS 15.0, *) {
                appearance.compactScrollEdgeAppearance = navBarAppearance
            }
        }
    }
}

