//
//  WeatherData.swift
//  WeatherTest
//
//  Created by KEEVIN MITCHELL on 9/13/24.
//

import Foundation
// Represents weather data fetched from the OpenWeather API.
struct WeatherData: Decodable {
  var coord: Coord
  var weather: [Weather]
  var base: String
  var main: Main
  var visibility: Int
  var wind: Wind
  var clouds: Cloud
  var dt: Date
  var sys: Sy
  var timezone: Int
  var id: Int
  var name: String
  var cod: Int
}

struct Coord: Decodable {
  var lon: Double
  var lat: Double
}

struct Weather: Decodable {
  var id: Int
  var main: String
  var description: String
  var icon: String
}

struct Main: Decodable {
  var temp: Double
  var feelsLike: Double
  var tempMin: Double
  var tempMax: Double
  var pressure: Int
  var humidity: Int
  var seaLevel: Int
  var grndLevel: Int

  private enum CodingKeys: String, CodingKey {
    case temp
    case feelsLike = "feels_like"
    case tempMin = "temp_min"
    case tempMax = "temp_max"
    case pressure
    case humidity
    case seaLevel = "sea_level"
    case grndLevel = "grnd_level"
  }
}

struct Wind: Decodable {
  var speed: Double
  var deg: Int?
  var gust: Double?
}

struct Cloud: Decodable {
  var all: Int
}

struct Sy: Decodable {
  var type: Int
  var id: Int
  var country: String
  var sunrise: Date
  var sunset: Date
}



enum WeatherError: Error, LocalizedError, Equatable {
    case invalidResponse
    case invalidCity
    case emptyTextField
    case illegalLetters
    case searchCountLessThanTwo
    case coordinatesError
    case networkError(Error)
    case locationError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return NSLocalizedString("The weather service returned an invalid response.", comment: "")
        case .invalidCity:
            return NSLocalizedString("The city name is not valid.", comment: "")
        case .emptyTextField:
            return NSLocalizedString("City name cannot be empty.", comment: "")
        case .illegalLetters:
            return NSLocalizedString("City name can only contain letters and spaces.", comment: "")
        case .searchCountLessThanTwo:
            return NSLocalizedString("City name must be at least 2 characters long.", comment: "")
        case .coordinatesError:
            return NSLocalizedString("Coordinates not found.", comment: "")
        case .networkError(let error):
            return error.localizedDescription
        case .locationError(let error):
            return error.localizedDescription
        }
    }
    
    // Conformance to Equatable
    static func == (lhs: WeatherError, rhs: WeatherError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidResponse, .invalidResponse):
            return true
        case (.invalidCity, .invalidCity):
            return true
        case(.emptyTextField, .emptyTextField):
            return true
        case(.illegalLetters, .illegalLetters):
            return true
        case(.searchCountLessThanTwo, .searchCountLessThanTwo):
            return true
        case(.coordinatesError, .coordinatesError):
            return true
        case (.networkError(let lhsError), .networkError(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)
        case (.locationError(let lhsError), .locationError(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)
        default:
            return false
        }
    }
}



