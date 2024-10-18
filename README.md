# FetchHiringApp

FetchHiringApp is a Swift-based iOS application that retrieves and displays a list of items from a remote JSON endpoint. The app groups the items by `listId`, sorts them, and filters out items with a blank or null `name`. It is built using the MVVM (Model-View-ViewModel) architecture pattern and utilizes SwiftUI for the user interface.

## Features

- Fetches data from a remote API.
- Groups items by `listId`.
- Sorts items within each group alphabetically by `name`.
- Filters out items where `name` is blank or null.
- Displays the list of items in an easy-to-read format.
- Handles loading states and error scenarios gracefully.

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern:
- **Model**: Represents the data retrieved from the network (e.g., `Item`).
- **ViewModel**: Manages data processing and provides the filtered and sorted data for display (e.g., `ItemViewModel`).
- **View**: Displays the user interface using SwiftUI (e.g., `ContentView`).

## Testing

### Unit Tests

Unit tests are provided to verify the functionality of the data filtering, sorting, and grouping:

- **Filtering out empty or nil names**
- **Handling network errors gracefully**
- **Grouping and sorting items correctly**
- **Loading an empty list**
- **Managing scenarios where some groups have no items**

### UI Tests

UI tests are provided to ensure the app behaves as expected:

- **Testing the loading indicator during data fetching**
- **Verifying the "No items available" message appears when there is no data**
- **Checking if the items are displayed in grouped sections when data is available**
