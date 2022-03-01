//
//  ItemCollectionViewCell.swift
//  ShoppingApp
//
//  Created by Morteza on 3/1/22.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell, CollectionViewCellConfigurable {
    typealias ItemType = Items
    
    typealias CellType = ItemCollectionViewCell
    
    
    static var reuseIdentifier = "ItemCVCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static func reuseIdentifierForIndexPath(indexPath: IndexPath) -> String {
        return reuseIdentifier
    }
    
    static func configureCellAtIndexPath(indexPath: IndexPath, item: ItemType, cell: CellType) {
    
    }
    
}
