//
//  ShoppingAppTests.swift
//  ShoppingAppTests
//
//  Created by Morteza on 2/27/22.
//

import XCTest
import Combine
@testable import ShoppingApp

class ShoppingAppTests: XCTestCase {

    var homeViewModel: HomeViewModel!
    var homeVC: HomeViewController!
    var anyCancellable = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        homeViewModel = HomeViewModel()
        homeVC = HomeViewController()
    }

    override func tearDownWithError() throws {
        homeViewModel = nil
        homeVC = nil
    }

    func testCategoryItemsIsNotNil() throws {
        let items = homeViewModel.categoryItems
        XCTAssertNotNil(items)
    }
    
    func testCategoryDataSourceIsValid() throws {
        homeVC.categorisDataSource = CollectionViewDataSource(data: homeViewModel.categoryItems)
        XCTAssertNotNil(homeVC.categorisDataSource)
    }
    
    func testHomeItemsHasValidValue() {
        let items: [Items]!
        items = [Items(hor: "sample", ver: "sample")]
        XCTAssertNotNil(items.first?.hor, items.first?.ver as! String)
    }
    
    func testBasicRequestGeneration() throws {
        let request = ItemRequest()
        XCTAssertEqual(request.path, "wallpaper/?search=nature&page=1")
    }

    func testApiLoadData() throws {
        let expectation = self.expectation(description: "fetch data")

        let mockNetwork = Network()
        let request = ItemRequest()
        mockNetwork.request(req: request).sink { _ in
        } receiveValue: { items in
            XCTAssertNotNil(items)
            expectation.fulfill()
        }.store(in: &anyCancellable)
        wait(for: [expectation], timeout: 5.0)
    }
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
