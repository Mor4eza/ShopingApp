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
    var dataSource: CollectionViewDataSource<[CategoryItem], CategoryCollectionViewCell>?
    var itemsDataSource: CollectionViewDataSource<[Items], ItemCollectionViewCell>?
    var items: [Items] {
        return [Items(hor: "123", ver: "132"),
                Items(hor: "321", ver: "321"),
                Items(hor: "321", ver: "321"),]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupViewCollectionView()
    }
    
    func setupViewCollectionView() {
        homeCategoryCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        
        itemsCollectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ItemCollectionViewCell.reuseIdentifier)

        
        dataSource = CollectionViewDataSource(data: homeViewModel.categoryItems)
        
        homeCategoryCollectionView.dataSource = dataSource
        homeCategoryCollectionView.delegate = dataSource

        homeCategoryCollectionView.backgroundColor = UIColor(named: "VCBackColor")
        itemsCollectionView.backgroundColor = UIColor(named: "VCBackColor")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 80.0, height: 140.0)
        homeCategoryCollectionView.collectionViewLayout = layout
        itemsCollectionView.collectionViewLayout = CollectionViewComposLayout().create()

    }
    
    func fetchData() {
        homeViewModel.getDataFromServer()
        homeViewModel.$items
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [self] items in
                print(items)
                itemsDataSource = CollectionViewDataSource(data: homeViewModel.items)
                itemsCollectionView.dataSource = itemsDataSource
                itemsCollectionView.reloadData()
            })
            .store(in: &anyCancellable)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCVCell", for: indexPath)
        return cell
    }
    
    
}
