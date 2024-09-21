//
//  CityServiceTests.swift
//  WeatherTestTests
//
//  Created by KEEVIN MITCHELL on 9/17/24.
//

import XCTest
@testable import WeatherTest

final class CityServiceTests: XCTestCase {
    var mockService: MockWeatherService!

    override func setUp() {
        super.setUp()
        mockService = MockWeatherService()
    }

    override func tearDown() {
        mockService = nil
        super.tearDown()
    }

    func testFetchCoordinatesSuccess() {
        // Given: The mock service will return a successful response
        mockService.shouldReturnError = false
        mockService.simulatedCities = [City(lat: 40.8860164, lon: -74.0072568)] // lon: -74.0072568, lat: 40.8860164

        let expectation = XCTestExpectation(description: "Fetch coordinates successfully")

        // When: Fetching coordinates for a specific city
        mockService.fetchCoordinates(for: "Teaneck") { result in
            // Then: The result should be a success with the expected city data
            switch result {
            case .success(let cities):
                XCTAssertEqual(cities.count, 1)
                XCTAssertEqual(cities.first?.lat, 40.8860164)
                XCTAssertEqual(cities.first?.lon, -74.0072568)
            case .failure:
                XCTFail("Expected a success result, but got a failure.")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchCoordinatesFailure() {
        // Given: The mock service will simulate an error
        mockService.shouldReturnError = true

        let expectation = XCTestExpectation(description: "Fetch coordinates with error")

        // When: Fetching coordinates for a specific city
        mockService.fetchCoordinates(for: "San Francisco") { result in
            // Then: The result should be a failure with the expected error
            switch result {
            case .success:
                XCTFail("Expected a failure result, but got a success.")
            case .failure(let error):
                XCTAssertEqual(error, .invalidCity)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
