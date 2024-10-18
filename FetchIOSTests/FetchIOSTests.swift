//
//  FetchHiringAppTests.swift
//  FetchHiringAppTests
//
//

import XCTest
@testable import FetchIOS

class FetchHiringAppTests: XCTestCase {

    // Mock Network Manager for Dependency Injection
    // This class simulates network behavior by providing mock data or simulating network errors.
    class MockNetworkManager: NetworkManaging {
        var mockItems: [Item] = [] // Mock data to return in fetchItems
        var shouldReturnError = false // Flag to simulate network error

        // Simulates fetching items with either success or failure based on shouldReturnError flag.
        func fetchItems(completion: @escaping (Result<[Item], Error>) -> Void) {
            if shouldReturnError {
                completion(.failure(NSError(domain: "MockError", code: 1, userInfo: nil)))
            } else {
                completion(.success(mockItems))
            }
        }
    }

    // Test to verify that items with empty or nil names are filtered out correctly.
    func testFilterOutEmptyOrNilNames() {
        // Arrange: Set up the mock network manager with test data.
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.mockItems = [
            Item(id: 1, listId: 1, name: "Apple"),
            Item(id: 2, listId: 1, name: ""),       // Should be filtered out
            Item(id: 3, listId: 1, name: nil),      // Should be filtered out
            Item(id: 4, listId: 1, name: "Banana")
        ]

        let viewModel = ItemViewModel(networkManager: mockNetworkManager)
        let expectation = XCTestExpectation(description: "Items are loaded and processed")

        // Act: Load the items through the view model.
        viewModel.loadItems {
            // Assert: Verify that only items with non-empty names are present.
            XCTAssertEqual(viewModel.filteredAndSortedItems.count, 1)
            XCTAssertEqual(viewModel.filteredAndSortedItems[0].count, 2)
            XCTAssertEqual(viewModel.filteredAndSortedItems[0][0].name, "Apple")
            XCTAssertEqual(viewModel.filteredAndSortedItems[0][1].name, "Banana")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    // Test to check the behavior when loading items fails (simulated network error).
    func testLoadItemsWithError() {
        // Arrange: Set up the mock network manager to simulate an error.
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.shouldReturnError = true

        let viewModel = ItemViewModel(networkManager: mockNetworkManager)
        let expectation = XCTestExpectation(description: "Error handling is tested")

        // Act: Load the items through the view model.
        viewModel.loadItems {
            // Assert: Verify that items are cleared and the view model handles the error correctly.
            XCTAssertTrue(viewModel.items.isEmpty, "Items should be empty when there is a network error")
            XCTAssertTrue(viewModel.filteredAndSortedItems.isEmpty, "Filtered and sorted items should also be empty on error")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    // Test to verify that items are correctly grouped by listId and sorted by name.
    func testGroupAndSortItems() {
        // Arrange: Set up the mock network manager with test data.
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.mockItems = [
            Item(id: 1, listId: 1, name: "Apple"),
            Item(id: 2, listId: 2, name: "Banana"),
            Item(id: 3, listId: 1, name: "Cherry"),
            Item(id: 4, listId: 2, name: "Date")
        ]

        let viewModel = ItemViewModel(networkManager: mockNetworkManager)
        let expectation = XCTestExpectation(description: "Items are grouped and sorted correctly")

        // Act: Load the items through the view model.
        viewModel.loadItems {
            // Assert: Verify that items are grouped by listId and sorted by name.
            XCTAssertEqual(viewModel.filteredAndSortedItems.count, 2)
            XCTAssertEqual(viewModel.filteredAndSortedItems[0].count, 2) // List ID 1
            XCTAssertEqual(viewModel.filteredAndSortedItems[1].count, 2) // List ID 2

            // Verify the order within each group
            XCTAssertEqual(viewModel.filteredAndSortedItems[0][0].name, "Apple")
            XCTAssertEqual(viewModel.filteredAndSortedItems[0][1].name, "Cherry")
            XCTAssertEqual(viewModel.filteredAndSortedItems[1][0].name, "Banana")
            XCTAssertEqual(viewModel.filteredAndSortedItems[1][1].name, "Date")

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    // Additional Test: Verify that an empty list is handled correctly.
    func testLoadEmptyList() {
        // Arrange: Set up the mock network manager with an empty item list.
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.mockItems = []

        let viewModel = ItemViewModel(networkManager: mockNetworkManager)
        let expectation = XCTestExpectation(description: "Empty list is handled correctly")

        // Act: Load the items through the view model.
        viewModel.loadItems {
            // Assert: Verify that filteredAndSortedItems is empty.
            XCTAssertTrue(viewModel.filteredAndSortedItems.isEmpty, "Filtered and sorted items should be empty when there are no items to load")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    // Additional Test: Verify that items are correctly grouped when multiple listIds are present but some groups have no items.
    func testGroupWithEmptyListIds() {
        // Arrange: Set up the mock network manager with items that cover multiple listIds, including one that will have no items after filtering.
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.mockItems = [
            Item(id: 1, listId: 1, name: "Apple"),
            Item(id: 2, listId: 2, name: ""),        // Should be filtered out
            Item(id: 3, listId: 3, name: "Cherry"),
            Item(id: 4, listId: 3, name: nil)         // Should be filtered out
        ]

        let viewModel = ItemViewModel(networkManager: mockNetworkManager)
        let expectation = XCTestExpectation(description: "Group with empty listIds is handled correctly")

        // Act: Load the items through the view model.
        viewModel.loadItems {
            // Assert: Verify the grouping and ensure that listId 2 is not present after filtering.
            XCTAssertEqual(viewModel.filteredAndSortedItems.count, 2)
            XCTAssertEqual(viewModel.filteredAndSortedItems[0].count, 1) // List ID 1
            XCTAssertEqual(viewModel.filteredAndSortedItems[1].count, 1) // List ID 3

            // Verify the correct items remain
            XCTAssertEqual(viewModel.filteredAndSortedItems[0][0].name, "Apple")
            XCTAssertEqual(viewModel.filteredAndSortedItems[1][0].name, "Cherry")

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
