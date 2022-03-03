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
    var categorisDataSource: CollectionViewDataSource<[CategoryItem], CategoryCollectionViewCell>?
    var itemsDataSource: CollectionViewDataSource<[Items], ItemCollectionViewCell>?
    var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
        setupCollectionViews()
        bindToPublishers()
    }
    
   private func setupCollectionViews() {
        homeCategoryCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        itemsCollectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ItemCollectionViewCell.reuseIdentifier)
        
        categorisDataSource = CollectionViewDataSource(data: homeViewModel.categoryItems)
        homeCategoryCollectionView.dataSource = categorisDataSource
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
    
    private func makeCategoryLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 80.0, height: 140.0)
        return layout
    }
    
    @objc func refreshData() {
        page = 1
        refreshControl.beginRefreshing()
        fetchData(page: page)
    }
    
    private func fetchData(page: Int) {
        homeViewModel.getDataFromServer(page: page)
    }
    
   private func bindToPublishers() {
           // bind items
       homeViewModel.$items
           .receive(on: DispatchQueue.main)
           .sink(receiveValue: { [weak self] items in
               guard let self = self else {return}
               self.itemsDataSource = CollectionViewDataSource(data: self.homeViewModel.items)
               self.itemsCollectionView.dataSource = self.itemsDataSource
               self.refreshControl.endRefreshing()
               self.itemsCollectionView.reloadData()
           })
           .store(in: &anyCancellable)
       
           //bind errors
       homeViewModel.$errorMessage
           .receive(on: DispatchQueue.main)
           .sink { [weak self] error in
               guard let self = self else {return}
               if !error.isEmpty {
                   self.showError(error)
               }
           }.store(in: &anyCancellable)
    }
    
    private func showError(_ message: String) {
        print(message)
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !homeViewModel.isLoadingData && indexPath.item == homeViewModel.items.count - 2 {
            page += 1
            fetchData(page: page)
        }
    }
}
