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
    
    /*private let apiKey = "https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid={4c968e89714b39eaf8624df9d89f5970}"*/ // Replace with your OpenWeatherMap API key.
    private let apiKey = "4c968e89714b39eaf8624df9d89f5970"
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    // Fetch coordinates for City.
    func  fetchCoordinates(for city: String, completion: @escaping (Result<[City], WeatherError>) -> Void) {
        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(city)&limit=1&appid=\(apiKey)"
        let request = URLRequest(url: URL(string: urlString)!) //TODO
        
        URLSession.shared.dataTask(with: request) { data, res, error in
            if let _ = error {
                completion(.failure(.invalidResponse)) //TODO
                return
            } else {
                let coordinates = try! JSONDecoder().decode([City].self, from: data!)
                //TODO invalid City
                completion(.success(coordinates))
            }
        }.resume()
        
    }
    // Fetch weather data using coordinates.
    func fetchWeather(for latitude: String, longitude: String, completion: @escaping (Result<WeatherData, WeatherError>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=4c968e89714b39eaf8624df9d89f5970"
        let request = URLRequest(url: URL(string: urlString)!)
        URLSession.shared.dataTask(with: request) { data, res, error in
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
