    //
    //  HomeViewModel.swift
    //  ShoppingApp
    //
    //  Created by Morteza on 2/27/22.
    //

import Foundation
import Combine

protocol HomeViewModelProtocol {
    var items: [Items] {get set}
    var categoryItems: [CategoryItem] {get}
    var anyCancelable: Set<AnyCancellable> {get set}
    func getDataFromServer()
}

class HomeViewModel: HomeViewModelProtocol {
    
    @Published var items = [Items]()
    internal var anyCancelable = Set<AnyCancellable>()
    
    var categoryItems: [CategoryItem] = {
        return [CategoryItem(emoji: "🔥", name: "Hot"),
                CategoryItem(emoji: "👩🏻", name: "Women"),
                CategoryItem(emoji: "👨🏻", name: "Men"),
                CategoryItem(emoji: "👠", name: "Shoes"),
                CategoryItem(emoji: "👔", name: "Formal")]
    }()
    
    
    init() {}
    
    func getDataFromServer() {
        let itemsRequest = ItemRequest()
        itemsRequest.page = 2
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
            } receiveValue: { [weak self] shopItems in
                guard let self = self else { return }
                self.items = shopItems.results
            }.store(in: &anyCancelable)
    }
}
