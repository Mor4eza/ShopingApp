//
//  HomeViewController.swift
//  ShoppingApp
//
//  Created by Morteza on 2/27/22.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    var observers = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("call service")
        var itemsRequest = ItemRequest()
         Network().request(req: itemsRequest)
            .mapError {$0}
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    case .finished:
                        print("done")
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { shopItems in
                print(shopItems.channel)
            }.store(in: &observers)


    }
    
}
