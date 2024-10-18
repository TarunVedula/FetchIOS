import SwiftUI

@main
struct FetchIOSApp: App {
    // Declare networkManager as a property of the App struct
    var networkManager: NetworkManaging

    // Initialize networkManager based on command line arguments
    init() {
        if CommandLine.arguments.contains("--mock-empty-data") {
            print("Using mock-empty-data")
            let mockNetworkManager = MockNetworkManager()
            mockNetworkManager.mockData = [] // Set the mock data to an empty array
            networkManager = mockNetworkManager
        } else if CommandLine.arguments.contains("--mock-network-error") {
            print("Using mock-network-error")
            let mockNetworkManager = MockNetworkManager()
            mockNetworkManager.shouldReturnError = true // Simulate a network error
            networkManager = mockNetworkManager
        } else if CommandLine.arguments.contains("--mock-with-data") {
            print("Using mock-with-data")
            let mockNetworkManager = MockNetworkManager()
            mockNetworkManager.mockData = [
                Item(id: 1, listId: 1, name: "Item 1"),
                Item(id: 2, listId: 1, name: "Item 2"),
                Item(id: 3, listId: 2, name: "Item 3")
            ] // Provide some test data
            networkManager = mockNetworkManager
        } else {
            print("Using real NetworkManager")
            networkManager = NetworkManager() // Use the real NetworkManager
        }
    }


    var body: some Scene {
        WindowGroup {
            // Now create ContentView after networkManager is set up
            ContentView(networkManager: networkManager)
        }
    }
}
