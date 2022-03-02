//
//  ItemRequest.swift
//  ShoppingApp
//
//  Created by Morteza on 2/27/22.
//

import Foundation

class ItemRequest: Requestable {
    typealias ResponseType = ShopItem
    var page = 1
    var path: String {
        return "wallpaper/?search=nature&page=\(page)"
    }
    
}
