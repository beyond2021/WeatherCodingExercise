//
//  WeatherViewModelTests.swift
//  WeatherTestTests
//
//  Created by KEEVIN MITCHELL on 9/21/24.
//

import XCTest
@testable import WeatherTest


class WeatherViewModelTests: XCTestCase {
    
    var viewModel: WeatherViewModel!
    var mockWeatherService: NewMock!
    
    override func setUp() {
        super.setUp()
        mockWeatherService = NewMock()
        viewModel = WeatherViewModel(weatherService: mockWeatherService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockWeatherService = nil
        super.tearDown()
    }
    
    // Test successful weather fetching
    func testFetchWeatherSuccess() {
        // Arrange
        let coordinates = [City(lat: 40.7128, lon: -74.0060)]
        let weatherData = WeatherData(coord: Coord(lon: -74.0072568, lat: 40.8860164),
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
        mockWeatherService.fetchCoordinatesResult = .success(coordinates)
        mockWeatherService.fetchWeatherResult = .success(weatherData)
        
        let expectation = self.expectation(description: "Weather fetch success")
        
        // Act
        viewModel.fetchWeather(for: "New York")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Assert
            XCTAssertNotNil(self.viewModel.weatherData)
            XCTAssertEqual(self.viewModel.weatherData?.main.temp, 290.53)
            XCTAssertNil(self.viewModel.errorMessage)
            XCTAssertFalse(self.viewModel.showErrorAlert)
            XCTAssertTrue(self.viewModel.isCityNameValid)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    // Test invalid city name (empty)
    func testInvalidCityNameEmpty() {
        // Arrange
        viewModel.cityName = ""
        
        // Act
        viewModel.searchWeather()
        
        // Assert
        XCTAssertFalse(viewModel.isCityNameValid)
        XCTAssertEqual(viewModel.errorMessage, WeatherError.emptyTextField.localizedDescription)
    }
    
    // Test invalid city name (contains numbers)
    func testInvalidCityNameWithNumbers() {
        // Arrange
        viewModel.cityName = "New York123"
        
        // Act
        viewModel.searchWeather()
        
        // Assert
        XCTAssertFalse(viewModel.isCityNameValid)
        XCTAssertEqual(viewModel.errorMessage, WeatherError.illegalLetters.localizedDescription)
    }
    
    // Test invalid city name (length less than 2)
    func testInvalidCityNameTooShort() {
        // Arrange
        viewModel.cityName = "N"
        
        // Act
        viewModel.searchWeather()
        
        // Assert
        XCTAssertFalse(viewModel.isCityNameValid)
        XCTAssertEqual(viewModel.errorMessage, WeatherError.searchCountLessThanTwo.localizedDescription)
    }
    
    // Test fetch coordinates failure
    func testFetchCoordinatesFailure() {
        // Arrange
        let error = WeatherError.networkError(NSError(domain: "com.example.network", code: -1001, userInfo: nil))
        mockWeatherService.fetchCoordinatesResult = .failure(error)
        
        let expectation = self.expectation(description: "Coordinates fetch failure")
        
        // Act
        viewModel.fetchWeather(for: "Invalid City")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Assert
            XCTAssertTrue(self.viewModel.showErrorAlert)
            XCTAssertEqual(self.viewModel.errorMessage, "Failed to fetch coordinates: The operation couldn’t be completed. (com.example.network error -1001.)")
            XCTAssertEqual(self.viewModel.navigationTitle, "Error")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    // Test fetch weather failure
    func testFetchWeatherFailure() {
        // Arrange
        let coordinates = [City(lat: 40.7128, lon: -74.0060)]
        let error = WeatherError.networkError(NSError(domain: "com.example.network", code: -1009, userInfo: nil))
        mockWeatherService.fetchCoordinatesResult = .success(coordinates)
        mockWeatherService.fetchWeatherResult = .failure(error)
        
        let expectation = self.expectation(description: "Weather fetch failure")
        
        // Act
        viewModel.fetchWeather(for: "New York")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Assert
            XCTAssertTrue(self.viewModel.showErrorAlert)
            XCTAssertEqual(self.viewModel.errorMessage, "The operation couldn’t be completed. (com.example.network error -1009.)")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
