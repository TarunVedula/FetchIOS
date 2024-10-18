// ContentView.swift
// This file defines the main view for the FetchIOS, which displays a list of items to the user.
// The view uses SwiftUI and follows the MVVM (Model-View-ViewModel) architecture pattern, with the ItemViewModel
// responsible for managing the data and the ContentView responsible for rendering the UI.

import SwiftUI

// The ContentView struct represents the main view of the application, displaying the list of items
// fetched from the network and handling different states such as loading, error, and displaying data.
struct ContentView: View {
    @StateObject var viewModel: ItemViewModel // The view model that manages the data for this view.
    @State private var isLoading: Bool = true // Tracks whether the data is currently being loaded.
    @State private var errorMessage: String? = nil // Holds any error message to display to the user.

    // CInitializer for ContentView, allowing dependency injection of a NetworkManaging instance.
    // It uses the real NetworkManager by defauly which makes it easier to use mock data for testing.
    init(networkManager: NetworkManaging = NetworkManager()) {
        _viewModel = StateObject(wrappedValue: ItemViewModel(networkManager: networkManager))
    }

    // The body property defines the view's layout, which consists of a navigation view with conditional
    // rendering based on the current state (loading, error, or displaying data).
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    // Display a loading indicator when data is being fetched.
                    ProgressView("Loading items...")
                } else if let errorMessage = errorMessage {
                    // Display an error message if there is an error.
                    VStack {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        Button(action: {
                            // Retry action when the "Retry" button is pressed.
                            loadItems()
                        }) {
                            Text("Retry")
                        }
                        .padding(.top, 10) // Add some padding above the button.
                    }
                } else if viewModel.filteredAndSortedItems.isEmpty {
                    // Display a message if there are no items available.
                    Text("No items available")
                        .accessibilityIdentifier("EmptyStateMessage") // Accessibility identifier for UI testing.
                } else {
                    // Display the list of grouped and sorted items when data is available.
                    List {
                        ForEach(viewModel.filteredAndSortedItems, id: \.self) { itemGroup in
                            // Display a section header for each group of items.
                            Section(header: Text("List ID: \(itemGroup.first?.listId ?? 0)").accessibilityIdentifier("ListIDSection")) {
                                // Display each item within the group.
                                ForEach(itemGroup, id: \.id) { item in
                                    Text(item.name ?? "Unknown")
                                        .accessibilityIdentifier("ItemName") // Accessibility identifier for UI testing.
                                }
                            }
                        }
                    }
                    .navigationTitle("Items List") // Set the title for the navigation bar.
                }
            }
            .onAppear {
                // Trigger the loading of items when the view appears.
                loadItems()
            }
        }
    }

    // Private method to load items using the view model and update the loading and error states.
    private func loadItems() {
        isLoading = true // Set isLoading to true to show the loading indicator.
        errorMessage = nil // Clear any previous error message.
        
        // Load items through the view model.
        viewModel.loadItems { [self] in
            DispatchQueue.main.async {
                self.isLoading = false // Hide the loading indicator once the data has been fetched.
                if self.viewModel.items.isEmpty {
                    // If no items were loaded, set an error message to indicate the failure.
                    self.errorMessage = "Failed to load items"
                }
            }
        }
    }
}
