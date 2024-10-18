//
//  FetchHiringAppUITests.swift
//  FetchHiringAppUITests
////

import XCTest

// Define the UI test class for FetchHiringApp
class FetchHiringAppUITests: XCTestCase {

    // Test the app's launch performance
    func testLaunchPerformance() {
        // Measure the time it takes for the app to launch
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            // Launch the application
            XCUIApplication().launch()
        }
    }
}
