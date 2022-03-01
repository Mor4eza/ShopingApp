    //
    //  CategoryCollectionViewCell.swift
    //  ShoppingApp
    //
    //  Created by Morteza on 2/27/22.
    //

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell, CollectionViewCellConfigurable {
    
    typealias ItemType = CategoryItem
    typealias CellType = CategoryCollectionViewCell
    
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    static var reuseIdentifier = "HomeCVCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
            // Initialization code
        contentView.backgroundColor = UIColor(named: "TabBackColor")
        contentView.layer.cornerRadius = 40.0
        emojiLabel.backgroundColor = .clear
        emojiLabel.layer.cornerRadius = emojiLabel.frame.width / 2
        emojiLabel.layer.borderWidth = 1
        emojiLabel.clipsToBounds = true
        emojiLabel.layer.borderColor = UIColor.gray.cgColor
        titleLabel.textColor = .lightGray
        layer.shadowColor = UIColor(named: "TabBackColor")?.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ?  UIColor(named: "SelectedCellBackColor") : UIColor(named: "TabBackColor")
            emojiLabel.backgroundColor = isSelected ? .white : .clear
            titleLabel.textColor = isSelected ? .white : .lightGray
            emojiLabel.layer.borderWidth = isSelected ? 0.0 : 1.0
            
        }
    }
    
    static func reuseIdentifierForIndexPath(indexPath: IndexPath) -> String {
        return reuseIdentifier
    }
    
    static func configureCellAtIndexPath(indexPath: IndexPath, item: ItemType, cell: CellType) {
      
        cell.emojiLabel.text = item.emoji
        cell.titleLabel.text = item.name
    }
}

