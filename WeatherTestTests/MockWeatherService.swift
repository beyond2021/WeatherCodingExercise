//
//  MockWeatherService.swift
//  WeatherTestTests
//
//  Created by KEEVIN MITCHELL on 9/17/24.
//

import Foundation
@testable import WeatherTest
class MockWeatherService: WeatherServiceProtocol {
    var shouldReturnError = false // Determines whether the mock service should simulate an error
    var simulatedWeatherData: WeatherData?
    var simulatedCities: [City]?
    // Protocol Functions
    func fetchCoordinates(for city: String, completion: @escaping (Result<[City], WeatherError>) -> Void) {
        // Simulate a network delay using DispatchQueue
        let seconds = 5.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
            if self.shouldReturnError {
                // Simulate an error scenario
                completion(.failure(.invalidCity))
            } else if let simulatedCities = self.simulatedCities {
                // Return simulated city data
                completion(.success(simulatedCities))
            } else {
                // Provide default mock data if no custom data is set
                /*let defaultCity = City(name: city, latitude: 37.7749, longitude: -122.4194)*/ // Example coordinates for San Francisco
                let defaultCity = City(lat: 40.8860164, lon: -74.0072568)
                completion(.success([defaultCity]))
            }
        }
    }
    // Protocol Functions
    func fetchWeather(for latitude: String, longitude: String, completion: @escaping (Result<WeatherData, WeatherError>) -> Void) {
        // Simulate a network delay using DispatchQueue
        let seconds = 5.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            if self.shouldReturnError {
                // Simulate an error scenario
                completion(.failure(.invalidCity))
            } else if let simulatedWeatherData = self.simulatedWeatherData {
                // Return simulated weather data
                completion(.success(simulatedWeatherData))
            } else {
                // Provide default mock data if no custom data is set
                let defaultWeatherData = WeatherData(coord: Coord(lon: -74.0072568, lat: 40.8860164),
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
                completion(.success(defaultWeatherData))
            }
        }
        
    }
}
