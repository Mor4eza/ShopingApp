//
//  CollectionViewDataSource.swift
//  ShoppingApp
//
//  Created by Morteza on 3/1/22.
//

import UIKit

protocol IndexPathIndexable {
    associatedtype ItemType
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> ItemType
    func numberOfSections() -> Int
    func numberOfItemsInSection(section: Int) -> Int
}


class CollectionViewDataSource<T: IndexPathIndexable, C: CollectionViewCellConfigurable>: NSObject, UICollectionViewDataSource where T.ItemType == C.ItemType {
    let data: T
    
    init(data: T) {
        self.data = data
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.numberOfItemsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = C.reuseIdentifierForIndexPath(indexPath: indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? C.CellType else {
            fatalError("Cells with reuse identifier \(reuseIdentifier) not of type \(C.CellType.self)")
        }
        let item = data.objectAtIndexPath(indexPath: indexPath as NSIndexPath)
        C.configureCellAtIndexPath(indexPath: indexPath, item: item, cell: cell)
        return cell
    }
    
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.section)
    }
}
