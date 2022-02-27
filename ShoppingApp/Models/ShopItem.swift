    //
    //  ShopItem.swift
    //  ShoppingApp
    //
    //  Created by Morteza on 2/27/22.
    //

import Foundation

struct ShopItem : Codable {
    var ok: Bool
    var channel: String
    var results: [Items]
}

struct Items: Codable {
    var hor: String
    var ver: String
}
