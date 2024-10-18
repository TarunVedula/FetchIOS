// ItemViewModel.swift
// This file defines the ItemViewModel class, which is responsible for managing the application's data state.
// It fetches data from the network, processes it (filtering, grouping, and sorting), and updates the state for the UI to reflect changes.

import Foundation
import Combine

// ItemViewModel class conforms to ObservableObject, allowing it to be used with SwiftUI for state management.
// ItemViewModel class conforms to ObservableObject, allowing it to be used with SwiftUI for state management.
class ItemViewModel: ObservableObject {
    @Published var items: [Item] = [] // Holds all fetched items.
    @Published var filteredAndSortedItems: [[Item]] = [] // Holds grouped and sorted items, ready for display in the UI.

    private let networkManager: NetworkManaging // Dependency to fetch data from the network.

    // Initializes to accept a network manager, enabling dependency injection for testing or real network requests.
    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }

    // Function to load items from the network. It accepts a completion handler that gets called after the network request completes.
    func loadItems(completion: @escaping () -> Void) {
        networkManager.fetchItems { [weak self] result in // Perform the network request.
            DispatchQueue.main.async { // Ensure that UI updates happen on the main thread.
                switch result {
                case .success(let items):
                    self?.items = items // Update the fetched items.
                    self?.filterAndSortItems(items) // Filter, group, and sort the items for display.
                case .failure(let error):
                    // Handle the error case, such as logging the error or showing an alert to the user.
                    print("Failed to load items: \(error.localizedDescription)")
                    self?.items = [] // Clear items if the fetch fails.
                    self?.filteredAndSortedItems = [] // Clear filtered items as well.
                }
                completion() // Call the completion handler to signal that the loading process is finished.
            }
        }
    }

    // Private function to filter out unwanted items, group them by listId, and sort them for display.
    private func filterAndSortItems(_ items: [Item]) {
        // Filter out items where the name is either empty or nil.
        let filteredItems = items.filter { !($0.name?.isEmpty ?? true) }
        
        // Group the filtered items by their listId property.
        let groupedItems = Dictionary(grouping: filteredItems, by: { $0.listId })
        
        //Sort the groups by listId and sort the items within each group by name in alphabetical order.
        let sortedGroups = groupedItems
            .sorted { $0.key < $1.key } // Sort the groups by listId in ascending order.
            .map { $0.value.sorted { ($0.name ?? "") < ($1.name ?? "") } } // Sort items within each group by their name.

        //Update the published property so that the UI can reflect these changes.
        self.filteredAndSortedItems = sortedGroups
    }
}
