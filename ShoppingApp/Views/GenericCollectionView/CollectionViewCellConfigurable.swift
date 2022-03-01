//
//  CollectionViewCellConfigurable.swift
//  ShoppingApp
//
//  Created by Morteza on 3/1/22.
//

import UIKit

protocol CollectionViewCellConfigurable {
    associatedtype ItemType
    associatedtype CellType: UICollectionViewCell
    
    static func reuseIdentifierForIndexPath(indexPath: IndexPath) -> String
    static func configureCellAtIndexPath(indexPath: IndexPath, item: ItemType, cell: CellType)
}
