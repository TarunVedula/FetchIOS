// Item.swift
// This file defines the Item struct, which represents a single item retrieved from the network.
// The struct conforms to Codable, Identifiable, and Hashable protocols
//

import Foundation

// The Item struct represents a data model for items fetched from the network.
// It conforms to Codable for easy decoding from JSON, Identifiable for use in SwiftUI's List and ForEach views, and Hashable for use in sets and dictionary keys.
struct Item: Codable, Identifiable, Hashable {
    let id: Int // The unique identifier for the item, required by the Identifiable protocol.
    let listId: Int // The identifier for the list to which this item belongs.
    let name: String? // The name of the item, which can be nil or empty.

    // The conformance to Hashable is automatically synthesized for structs when all of its stored properties conform to Hashable
    // which enables the struct to be used in collections that require Hashable conformance, such as sets or as dictionary keys.
}
