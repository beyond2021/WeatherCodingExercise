//
//  WeatherErrorTests.swift
//  WeatherTestTests
//
//  Created by KEEVIN MITCHELL on 9/23/24.
//

import XCTest

import XCTest

class WeatherErrorTests: XCTestCase {

    // Test error descriptions
    func testErrorDescriptions() {
        XCTAssertEqual(WeatherError.invalidResponse.errorDescription, "The weather service returned an invalid response.")
        XCTAssertEqual(WeatherError.invalidCity.errorDescription, "The city name is not valid.")
        XCTAssertEqual(WeatherError.emptyTextField.errorDescription, "City name cannot be empty.")
        XCTAssertEqual(WeatherError.illegalLetters.errorDescription, "City name can only contain letters and spaces.")
        XCTAssertEqual(WeatherError.searchCountLessThanTwo.errorDescription, "City name must be at least 2 characters long.")
        XCTAssertEqual(WeatherError.coordinatesError.errorDescription, "Coordinates not found.")
    }

    // Test error descriptions for networkError and locationError
    func testNetworkErrorDescription() {
        let underlyingError = NSError(domain: "com.example.network", code: -1009, userInfo: [NSLocalizedDescriptionKey: "The Internet connection appears to be offline."])
        let weatherError = WeatherError.networkError(underlyingError)
        
        XCTAssertEqual(weatherError.errorDescription, "The Internet connection appears to be offline.")
    }

    func testLocationErrorDescription() {
        let underlyingError = NSError(domain: "com.example.location", code: -1, userInfo: [NSLocalizedDescriptionKey: "Location services disabled."])
        let weatherError = WeatherError.locationError(underlyingError)
        
        XCTAssertEqual(weatherError.errorDescription, "Location services disabled.")
    }

    // Test Equatable conformance
    func testEquality() {
        XCTAssertEqual(WeatherError.invalidResponse, WeatherError.invalidResponse)
        XCTAssertEqual(WeatherError.invalidCity, WeatherError.invalidCity)
        XCTAssertEqual(WeatherError.emptyTextField, WeatherError.emptyTextField)
        XCTAssertEqual(WeatherError.illegalLetters, WeatherError.illegalLetters)
        XCTAssertEqual(WeatherError.searchCountLessThanTwo, WeatherError.searchCountLessThanTwo)
        XCTAssertEqual(WeatherError.coordinatesError, WeatherError.coordinatesError)

        let networkError1 = NSError(domain: "com.example.network", code: -1009, userInfo: nil)
        let networkError2 = NSError(domain: "com.example.network", code: -1009, userInfo: nil)
        XCTAssertEqual(WeatherError.networkError(networkError1), WeatherError.networkError(networkError2))

        let locationError1 = NSError(domain: "com.example.location", code: -1, userInfo: nil)
        let locationError2 = NSError(domain: "com.example.location", code: -1, userInfo: nil)
        XCTAssertEqual(WeatherError.locationError(locationError1), WeatherError.locationError(locationError2))
    }

    // Test inequality
    func testInequality() {
        XCTAssertNotEqual(WeatherError.invalidResponse, WeatherError.invalidCity)

        let networkError1 = NSError(domain: "com.example.network", code: -1009, userInfo: nil)
        let networkError2 = NSError(domain: "com.example.network", code: -1001, userInfo: nil)
        XCTAssertNotEqual(WeatherError.networkError(networkError1), WeatherError.networkError(networkError2))

        let locationError1 = NSError(domain: "com.example.location", code: -1, userInfo: nil)
        let locationError2 = NSError(domain: "com.example.location", code: -2, userInfo: nil)
        XCTAssertNotEqual(WeatherError.locationError(locationError1), WeatherError.locationError(locationError2))
    }
}
