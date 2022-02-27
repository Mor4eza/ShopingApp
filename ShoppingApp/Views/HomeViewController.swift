//
//  HomeViewController.swift
//  ShoppingApp
//
//  Created by Morteza on 2/27/22.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeCategoryCollectionView: UICollectionView!
    
    var anyCancelable = Set<AnyCancellable>()
    var homeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupViewCollectionView()
    }
    
    func setupViewCollectionView() {
        homeCategoryCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCVCell")
        homeCategoryCollectionView.delegate = self
        homeCategoryCollectionView.dataSource = self
        homeCategoryCollectionView.backgroundColor = UIColor(named: "VCBackColor")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 80.0, height: 140.0)
        homeCategoryCollectionView.collectionViewLayout = layout

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

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return homeViewModel.categoryItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVCell", for: indexPath) as! HomeCollectionViewCell
        cell.item = homeViewModel.categoryItems[indexPath.item]
        return cell
    }

    
    
}
