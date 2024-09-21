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
    @Published var inValidCity: Bool = false
    
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
        weatherService.fetchCoordinates(for: city) { [weak self] result in
            if case .success (let coodinate) = result {
                if coodinate.isEmpty {
                    DispatchQueue.main.async {
                        self?.showErrorAlert = true
                        self?.errorMessage = "City not found"
                        self?.navigationTitle = "Invalid City"
                        self?.inValidCity = true
                    }
                   
                    return
                    
                }
                DispatchQueue.main.async {
                    self?.inValidCity = false
                }
                
//                print(">>> done  \(coodinate.first?.lat ?? 40.8860164), \(coodinate.first?.lon ?? -74.0072568)")
                self?.weatherService.fetchWeather(for: "\(coodinate.first?.lat ?? 40.8860164 )", longitude: "\(coodinate.first?.lon ?? -74.0072568)") { result in
                    if case .success(let weather) = result {
//                        print(">>> done sequentially \(weather)")
                        DispatchQueue.main.async {
                            self?.handleWeatherResult(result)
                        }
                    }
                }
                
            }
            if case.failure(let failure) = result {
                print(">>> \(failure)")
            }
            
        }
    }
    //  Fetch weather data for the current location.
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
                errorMessage = "City name cannot be empty."
                return
            }
            
            // Check if the city name contains only valid characters (letters and spaces)
            let characterSet = CharacterSet.letters.union(.whitespaces)
            if cityName.rangeOfCharacter(from: characterSet.inverted) != nil {
                isCityNameValid = false
                errorMessage = "City name can only contain letters and spaces."
                return
            }
            
            // Additional checks can be added, such as length validation
            if cityName.count < 2 {
                isCityNameValid = false
                errorMessage = "City name must be at least 2 characters long."
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
            
            // Continue with the search logic
            // Example: Call weather service API
      
    }

}

