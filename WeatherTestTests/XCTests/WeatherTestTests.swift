//
//  WeatherTestTests.swift
//  WeatherTestTests
//
//  Created by KEEVIN MITCHELL on 9/13/24.
//

import XCTest
@testable import WeatherTest

final class WeatherServiceTests: XCTestCase {
    var mockService: MockWeatherService!

    override func setUp() {
        super.setUp()
        mockService = MockWeatherService()
    }

    override func tearDown() {
        mockService = nil
        super.tearDown()
    }

    func testFetchWeatherSuccess() {
        // Given: The mock service will return a successful response
        mockService.shouldReturnError = false
        mockService.simulatedWeatherData = WeatherData(coord: Coord(lon: -74.0072568, lat: 40.8860164),
                                                       weather: [Weather(id: 804, main: "Clouds", description: "overcast clouds", icon: "04n")],
                                                       base: "stations",
                                                       main: Main.init(temp: 290.53, feelsLike: 290.57, tempMin: 292.54, tempMax: 292.54, pressure: 1024, humidity: 86, seaLevel: 1024, grndLevel: 1020),
                                                       visibility: 10000,
                                                       wind: Wind(speed: 3.6),
                                                       clouds: Cloud(all: 100),
                                                       dt: .now,
                                                       sys: Sy.init(type: 2, id: 2043938, country: "US", sunrise: .now, sunset: .now),
                                                       timezone: -14400,
                                                       id: 5105262,
                                                       name: "Teaneck",
                                                       cod: 200)

        let expectation = XCTestExpectation(description: "Fetch weather data successfully")

        // When: Fetching weather for specific coordinates
        mockService.fetchWeather(for: "40.8860164", longitude: "-74.0072568") { result in
            // Then: The result should be a success with the expected weather data
            switch result {
            case .success(let weatherData):
                XCTAssertEqual(weatherData.name, "Teaneck")
                XCTAssertEqual(weatherData.main.temp, 290.53)
            case .failure:
                XCTFail("Expected a success result, but got a failure.")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchWeatherFailure() {
        // Given: The mock service will simulate an error
        mockService.shouldReturnError = true

        let expectation = XCTestExpectation(description: "Fetch weather data with error")

        // When: Fetching weather for specific coordinates
        mockService.fetchWeather(for: "37.7749", longitude: "-122.4194") { result in
            // Then: The result should be a failure with the expected error
            switch result {
            case .success:
                XCTFail("Expected a failure result, but got a success.")
            case .failure(let error):
                XCTAssertEqual(error, .invalidCity)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
