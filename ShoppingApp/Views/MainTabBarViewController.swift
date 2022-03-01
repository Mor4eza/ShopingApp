//
//  MainTabBarViewController.swift
//  ShoppingApp
//
//  Created by Morteza on 2/27/22.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 1
        guard let childViewControllers = self.viewControllers else { return }
        for vc in childViewControllers {
            vc.view.backgroundColor = UIColor(named: "VCBackColor")
        }
    }
    
}

