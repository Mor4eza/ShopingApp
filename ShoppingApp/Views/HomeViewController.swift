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
    
    let refreshControl = UIRefreshControl(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    var anyCancellable = Set<AnyCancellable>()
    var homeViewModel = HomeViewModel()
    var dataSource: CollectionViewDataSource<[CategoryItem], CategoryCollectionViewCell>?
    var itemsDataSource: CollectionViewDataSource<[Items], ItemCollectionViewCell>?
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(page: 1)
        setupViewCollectionViews()
    }
    
    func setupViewCollectionViews() {
        homeCategoryCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        itemsCollectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ItemCollectionViewCell.reuseIdentifier)
        
        dataSource = CollectionViewDataSource(data: homeViewModel.categoryItems)
        homeCategoryCollectionView.dataSource = dataSource
        itemsCollectionView.delegate = self
        
        homeCategoryCollectionView.backgroundColor = UIColor(named: "VCBackColor")
        itemsCollectionView.backgroundColor = UIColor(named: "VCBackColor")
        
        homeCategoryCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .bottom)
        
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        itemsCollectionView.refreshControl = refreshControl
        
        
        homeCategoryCollectionView.collectionViewLayout = makeCategoryLayout()
        itemsCollectionView.collectionViewLayout = CollectionViewComposLayout().create()
        
    }
    
    func makeCategoryLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 80.0, height: 140.0)
        return layout
    }
    
    @objc func refreshData() {
        page = 1
        fetchData(page: page)
    }
    
    func fetchData(page: Int) {
        homeViewModel.getDataFromServer(page: page)
        homeViewModel.$items
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [self] items in
                itemsDataSource = CollectionViewDataSource(data: homeViewModel.items)
                itemsCollectionView.dataSource = itemsDataSource
                refreshControl.endRefreshing()
                itemsCollectionView.reloadData()
            })
            .store(in: &anyCancellable)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !homeViewModel.isLoadingData && indexPath.item == homeViewModel.items.count - 2 {
            print("load more")
            page += 1
            fetchData(page: page)
        }
    }
}
