//
//  WeatherViewModel.swift
//  WeatherTest
//
//  Created by KEEVIN MITCHELL on 9/13/24.
//

import Foundation
import CoreLocation
import SwiftUI

class WeatherViewModel: ObservableObject {
    @ObservedObject private var locationManager = LocationManager()
    private let weatherService: WeatherServiceProtocol
    @Published var weatherData: WeatherData?
    //
    @Published var cityName: String = ""
    @Published var isCityNameValid: Bool = true
    
    //Error
    @Published var errorMessage: String?
    @Published var showErrorAlert: Bool = false
//    @Published var inValidCity: Bool = false
    
    //NavigationTitle
    @Published var navigationTitle: String = "Weather App ✨"
    
    // Dependency Injection: Inject the weather service.
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    var formatter : MeasurementFormatter {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        return formatter
    }
    func fetchWeather(for city: String) {
        // Step 1: Fetch coordinates for the city
        weatherService.fetchCoordinates(for: city) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let coordinates):
                if coordinates.isEmpty {
                    // Handle case when no coordinates are found
                    DispatchQueue.main.async {
                        self.showErrorAlert = true
                        self.errorMessage = "Invalid City"
                        self.navigationTitle = "Invalid City"
                        self.isCityNameValid = false
                    }
                    return
                }
                // Coordinates are valid, fetch weather
                guard let latitude = coordinates.first?.lat, let longitude = coordinates.first?.lon else {
                    // Handle the case where coordinates exist but lat/lon is nil
                    DispatchQueue.main.async {
                        self.showErrorAlert = true
                        self.errorMessage = WeatherError.coordinatesError.localizedDescription
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.isCityNameValid = true
                }
                // Step 2: Fetch weather using the valid coordinates
                self.weatherService.fetchWeather(for: "\(latitude)", longitude: "\(longitude)") { weatherResult in
                    DispatchQueue.main.async {
                        self.handleWeatherResult(weatherResult)
                    }
                }
            
            case .failure(let error):
                // Handle error from fetching coordinates
                DispatchQueue.main.async {
                    self.showErrorAlert = true
                    self.errorMessage = "Failed to fetch coordinates: \(error.localizedDescription)"
                    self.navigationTitle = "Error"
                }
            }
        }
    }
    // Handle the result of a weather fetch operation.
    private func handleWeatherResult(_ result: Result<WeatherData, WeatherError>) {
        switch result {
        case .success(let weatherData):
            self.weatherData = weatherData
            self.errorMessage = nil
        case .failure(let error):
            self.errorMessage = error.localizedDescription
            self.showErrorAlert = true  // Trigger the alert
        }
    }
    func convertKelvinToFarhrenheit() -> String {
        if let weatherData = self.weatherData {
            let t = Measurement(value: weatherData.main.temp.rounded(), unit: UnitTemperature.kelvin)
            return formatter.string(from: t.converted(to: .fahrenheit))
        }
        return "N/A"
    }
    func checkPermissionStatus() {
        locationManager.checkIfLocationServicesIsEnabled()
    }
    
}

extension WeatherViewModel {
   
        func validateCityName() {
            // Check if the city name is not empty
            guard !cityName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                isCityNameValid = false
                errorMessage = WeatherError.emptyTextField.localizedDescription
//                showErrorAlert = true
                return
            }
            
            // Check if the city name contains only valid characters (letters and spaces)
            let characterSet = CharacterSet.letters.union(.whitespaces)
            if cityName.rangeOfCharacter(from: characterSet.inverted) != nil {
                isCityNameValid = false
                errorMessage = WeatherError.illegalLetters.localizedDescription
//                showErrorAlert = true
                return
            }
            
            // Additional checks can be added, such as length validation
            if cityName.count < 2 {
                isCityNameValid = false
                errorMessage = WeatherError.searchCountLessThanTwo.localizedDescription
//                showErrorAlert = true
                return
            }
            
            // If all validations pass
            isCityNameValid = true
            errorMessage = nil
        }
        
        func searchWeather() {
            validateCityName()
            
            guard isCityNameValid else {
                return // Exit if the city name is not valid
            }
           
    }

}

