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
        selectedIndex = 2
        self.view.backgroundColor = UIColor(named: "VCBackColor")
    }

}

