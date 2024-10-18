// NetworkManager.swift
// This file defines network-related classes and protocols for fetching items from a remote source or providing mock data for testing purposes.

import Foundation

// The NetworkManaging protocol abstracts the data-fetching functionality.
// This allows for dependency injection and makes it easy to swap out the real network manager for a mock version during testing.
protocol NetworkManaging {
    // Method to fetch items, returning the result asynchronously via a completion handler.
    // The result can be either a success with an array of Item objects or a failure with an error.
    func fetchItems(completion: @escaping (Result<[Item], Error>) -> Void)
}

// NetworkManager class conforms to the NetworkManaging protocol and implements the real network-fetching functionality.
class NetworkManager: NetworkManaging {
    // Initializer for the NetworkManager.
    init() {}

    // Method to fetch items from a remote URL.
    func fetchItems(completion: @escaping (Result<[Item], Error>) -> Void) {
        // Validate the URL. If the URL is invalid, return without making a network request.
        guard let url = URL(string: "https://fetch-hiring.s3.amazonaws.com/hiring.json") else { return }

        // Create a data task to fetch data from the specified URL.
        URLSession.shared.dataTask(with: url) { data, response, error in
            // If an error occurs during the network request, complete with a failure result.
            if let error = error {
                completion(.failure(error))
                return
            }

            // Ensure data is not nil. If it is, return without attempting to parse.
            guard let data = data else { return }

            do {
                // Try to decode the fetched JSON data into an array of Item objects.
                let items = try JSONDecoder().decode([Item].self, from: data)
                // If successful, complete with a success result containing the array of items.
                completion(.success(items))
            } catch {
                // If unsuccessful, complete with a failure result.
                completion(.failure(error))
            }
        }.resume() // Start the network request.
    }
}

// MockNetworkManager for testing purposes.
// This class conforms to the NetworkManaging protocol and provides mock data or simulates network errors.
// It is useful for testing the app's behavior without making real network requests.
class MockNetworkManager: NetworkManaging {
    var shouldReturnError = false // Determines whether the mock should simulate a network error.
    var mockData: [Item] = [] // Holds mock data to be returned when no error is simulated.

    // Method to fetch item that uses mock data or simulated error.
    func fetchItems(completion: @escaping (Result<[Item], Error>) -> Void) {
        if shouldReturnError {
            // If shouldReturnError is true, simulate a network error.
            completion(.failure(NSError(domain: "Network Error", code: 1, userInfo: nil)))
        } else {
            // Otherwise, complete with the provided mock data.
            completion(.success(mockData))
        }
    }
}
