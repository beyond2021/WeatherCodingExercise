//
//  WeatherDataTests.swift
//  WeatherTestTests
//
//  Created by KEEVIN MITCHELL on 9/17/24.
//

import XCTest
@testable import WeatherTest

final class WeatherDataTests: XCTestCase {
    func testWeatherDataDecoding() throws {
        // Sample JSON data
        let jsonData = """
        {
            "coord": { "lon": -122.08, "lat": 37.39 },
            "weather": [
                { "id": 800, "main": "Clear", "description": "clear sky", "icon": "01d" }
            ],
            "base": "stations",
            "main": {
                "temp": 282.55,
                "feels_like": 281.86,
                "temp_min": 280.37,
                "temp_max": 284.26,
                "pressure": 1023,
                "humidity": 100,
                "sea_level": 1030,
                "grnd_level": 1010
            },
            "visibility": 16093,
            "wind": { "speed": 1.5, "deg": 350, "gust": 3.0 },
            "clouds": { "all": 1 },
            "dt": 1560350645,
            "sys": {
                "type": 1,
                "id": 5122,
                "country": "US",
                "sunrise": 1560343627,
                "sunset": 1560396563
            },
            "timezone": -25200,
            "id": 420006353,
            "name": "Mountain View",
            "cod": 200
        }
        """.data(using: .utf8)!
        
        // Use JSONDecoder to decode the data
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let weatherData = try decoder.decode(WeatherData.self, from: jsonData)
        
        // Assert WeatherData fields
        XCTAssertEqual(weatherData.coord.lon, -122.08)
        XCTAssertEqual(weatherData.coord.lat, 37.39)
        
        XCTAssertEqual(weatherData.weather.count, 1)
        XCTAssertEqual(weatherData.weather.first?.id, 800)
        XCTAssertEqual(weatherData.weather.first?.main, "Clear")
        XCTAssertEqual(weatherData.weather.first?.description, "clear sky")
        XCTAssertEqual(weatherData.weather.first?.icon, "01d")
        
        XCTAssertEqual(weatherData.base, "stations")
        
        XCTAssertEqual(weatherData.main.temp, 282.55)
        XCTAssertEqual(weatherData.main.feelsLike, 281.86)
        XCTAssertEqual(weatherData.main.tempMin, 280.37)
        XCTAssertEqual(weatherData.main.tempMax, 284.26)
        XCTAssertEqual(weatherData.main.pressure, 1023)
        XCTAssertEqual(weatherData.main.humidity, 100)
        XCTAssertEqual(weatherData.main.seaLevel, 1030)
        XCTAssertEqual(weatherData.main.grndLevel, 1010)
        
        XCTAssertEqual(weatherData.visibility, 16093)
        
        XCTAssertEqual(weatherData.wind.speed, 1.5)
        XCTAssertEqual(weatherData.wind.deg, 350)
        XCTAssertEqual(weatherData.wind.gust, 3.0)
        
        XCTAssertEqual(weatherData.clouds.all, 1)
        
        XCTAssertEqual(weatherData.dt.timeIntervalSince1970, 1560350645)
        
        XCTAssertEqual(weatherData.sys.type, 1)
        XCTAssertEqual(weatherData.sys.id, 5122)
        XCTAssertEqual(weatherData.sys.country, "US")
        XCTAssertEqual(weatherData.sys.sunrise.timeIntervalSince1970, 1560343627)
        XCTAssertEqual(weatherData.sys.sunset.timeIntervalSince1970, 1560396563)
        
        XCTAssertEqual(weatherData.timezone, -25200)
        XCTAssertEqual(weatherData.id, 420006353)
        XCTAssertEqual(weatherData.name, "Mountain View")
        XCTAssertEqual(weatherData.cod, 200)
    }
}
