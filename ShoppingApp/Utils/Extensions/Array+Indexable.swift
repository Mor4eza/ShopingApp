//
//  Array+Indexable.swift
//  ShoppingApp
//
//  Created by Morteza on 3/1/22.
//

import Foundation

extension Array: IndexPathIndexable {
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> Element {
        return self[indexPath.item]
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return count
    }
}
