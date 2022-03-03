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
    var isLoadingData: Bool {get set}
    var errorMessage: String {get set}

    func getDataFromServer(page: Int)
}

class HomeViewModel: HomeViewModelProtocol {
    
    @Published var items = [Items]()
    internal var anyCancelable = Set<AnyCancellable>()
    @Published var errorMessage = ""

     lazy var categoryItems: [CategoryItem] = {
        return [CategoryItem(emoji: "🔥", name: "Hot"),
                CategoryItem(emoji: "👩🏻", name: "Women"),
                CategoryItem(emoji: "👨🏻", name: "Men"),
                CategoryItem(emoji: "👠", name: "Shoes"),
                CategoryItem(emoji: "👔", name: "Formal")]
    }()
    
    var isLoadingData = false
    
    init() {}
    
    func getDataFromServer(page: Int) {
        let itemsRequest = ItemRequest()
        itemsRequest.page = page
        isLoadingData = true
        Network().request(req: itemsRequest)
            .mapError {$0}
            .receive(on: DispatchQueue.main)
            .sink { [self] completion in
                switch completion {
                    case .finished:
                        print("done")
                    case .failure(let error):
                        let errorMessage = error.message
                        self.errorMessage = errorMessage
                        print(errorMessage)
                }
            } receiveValue: { [weak self] shopItems in
                guard let self = self else { return }
                if page == 1 {
                    self.items.removeAll()
                }
                self.items.append(contentsOf: shopItems.results)
                self.isLoadingData = false
            }.store(in: &anyCancelable)
    }
}
