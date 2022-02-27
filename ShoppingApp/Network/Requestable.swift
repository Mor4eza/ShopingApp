//
//  Requestable.swift
//  ShoppingApp
//
//  Created by Morteza on 2/27/22.
//

import Foundation

protocol Requestable {
    
    associatedtype ResponseType: Codable
    
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any] { get }
}

extension Requestable {
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String: Any] {
        return ["": ""]
    }
}

enum HTTPMethod: String {
    //TODO: add more http methods
    case get = "GET"
    case post = "POST"
}
