//
//  CityTests.swift
//  WeatherTestTests
//
//  Created by KEEVIN MITCHELL on 9/17/24.
//

import XCTest
@testable import WeatherTest // Replace with your app's module name

final class CityTests: XCTestCase {
    func testCityDecoding() throws {
        // Sample JSON data
        let jsonData = """
        {
            "name": "San Francisco",
            "local_names": {
                "en": "San Francisco",
                "es": "San Francisco",
                "fr": "San Francisco",
                "de": "San Francisco"
            },
            "lat": 37.7749,
            "lon": -122.4194,
            "country": "US",
            "state": "CA"
        }
        """.data(using: .utf8)!
        
        // Use JSONDecoder to decode the data
        let decoder = JSONDecoder()
        
        let city = try decoder.decode(City.self, from: jsonData)
        
        // Assert City fields
        XCTAssertEqual(city.name, "San Francisco")
        XCTAssertEqual(city.lat, 37.7749)
        XCTAssertEqual(city.lon, -122.4194)
        XCTAssertEqual(city.country, "US")
        XCTAssertEqual(city.state, "CA")
        
        // Assert LocalName fields
        XCTAssertNotNil(city.localNames)
        XCTAssertEqual(city.localNames?.en, "San Francisco")
        XCTAssertEqual(city.localNames?.es, "San Francisco")
        XCTAssertEqual(city.localNames?.fr, "San Francisco")
        XCTAssertEqual(city.localNames?.de, "San Francisco")
    }
}
