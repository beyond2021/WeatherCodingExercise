//
//  WeatherService.swift
//  WeatherTest
//
//  Created by KEEVIN MITCHELL on 9/13/24.
// https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid={4c968e89714b39eaf8624df9d89f5970}

import Foundation
import CoreLocation

// Protocol for the weather service to allow easy testing and dependency injection.
protocol WeatherServiceProtocol {
    func fetchCoordinates(for city: String, completion: @escaping (Result<[City], WeatherError>) -> Void)
    func fetchWeather(for latitude: String, longitude: String, completion: @escaping (Result<WeatherData, WeatherError>) -> Void)
}

class WeatherService: WeatherServiceProtocol {
    private let apiKey = "4c968e89714b39eaf8624df9d89f5970" // Use a proxy Server
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    // Fetch coordinates for City.
    func  fetchCoordinates(for city: String, completion: @escaping (Result<[City], WeatherError>) -> Void) {
        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(city)&limit=1&appid=\(apiKey)"
        guard let request = URL(string: urlString) else {
            completion(.failure(.invalidCity))
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            guard let data = data, let cityResponse = try? JSONDecoder().decode([City].self, from: data) else {
                completion(.failure(.invalidResponse))
                return
            }
            completion(.success(cityResponse))
        }
        .resume()
    }
    // Fetch weather data using coordinates.
    func fetchWeather(for latitude: String, longitude: String, completion: @escaping (Result<WeatherData, WeatherError>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=4c968e89714b39eaf8624df9d89f5970"
        guard let request = URL(string: urlString) else {
            completion(.failure(.invalidCity))
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            guard let data = data, let weatherResponse = try? JSONDecoder().decode(WeatherData.self, from: data) else {
                completion(.failure(.invalidResponse))
                return
            }
            completion(.success(weatherResponse))
        }.resume()
    }
}
