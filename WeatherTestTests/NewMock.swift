//
//  NewMock.swift
//  WeatherTestTests
//
//  Created by KEEVIN MITCHELL on 9/21/24.
//

// Mock for WeatherServiceProtocol
class NewMock: WeatherServiceProtocol {
    var fetchCoordinatesResult: Result<[City], WeatherError>?
    var fetchWeatherResult: Result<WeatherData, WeatherError>?
    
    func fetchCoordinates(for city: String, completion: @escaping (Result<[City], WeatherError>) -> Void) {
        if let result = fetchCoordinatesResult {
            completion(result)
        }
    }
    
    func fetchWeather(for latitude: String, longitude: String, completion: @escaping (Result<WeatherData, WeatherError>) -> Void) {
        if let result = fetchWeatherResult {
            completion(result)
        }
    }
}
