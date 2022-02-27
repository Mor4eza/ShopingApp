//
//  HomeViewController.swift
//  ShoppingApp
//
//  Created by Morteza on 2/27/22.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    var anyCancelable = Set<AnyCancellable>()
    var homeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func setupView() {
        view.backgroundColor = UIColor(named: "VCBackColor")
    }
    
    func fetchData() {
        homeViewModel.getDataFromServer()
        homeViewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { _ in
                print("data fetch")
            }
            .store(in: &anyCancelable)
    }
    
}
