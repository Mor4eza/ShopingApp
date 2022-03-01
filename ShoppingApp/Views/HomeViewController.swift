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
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    
    var anyCancellable = Set<AnyCancellable>()
    var homeViewModel = HomeViewModel()
    var dataSource: CollectionViewDataSource<Array<CategoryItem>, CategoryCollectionViewCell>?
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        dataSource = CollectionViewDataSource(data: homeViewModel.categoryItems)
        setupViewCollectionView()
    }
    
    func setupViewCollectionView() {
        homeCategoryCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        homeCategoryCollectionView.dataSource = dataSource
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
            .store(in: &anyCancellable)
    }
}

