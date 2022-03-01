//
//  ItemCollectionViewCell.swift
//  ShoppingApp
//
//  Created by Morteza on 3/1/22.
//

import UIKit
import Kingfisher

class ItemCollectionViewCell: UICollectionViewCell, CollectionViewCellConfigurable {
    typealias ItemType = Items
    typealias CellType = ItemCollectionViewCell
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    static var reuseIdentifier = "ItemCVCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
        itemImageView.layer.cornerRadius = 15.0
        contentView.clipsToBounds = true
    }

    static func reuseIdentifierForIndexPath(indexPath: IndexPath) -> String {
        return reuseIdentifier
    }
    
    static func configureCellAtIndexPath(indexPath: IndexPath, item: ItemType, cell: CellType) {
        
        guard let verUrl = URL(string: item.ver), let horUrl = URL(string: item.hor) else { return }

        if cell.frame.width <= cell.frame.height {
            cell.itemImageView.loadImage(url: verUrl)

        } else {
            cell.itemImageView.loadImage(url: horUrl)

        }
    }
    
}
