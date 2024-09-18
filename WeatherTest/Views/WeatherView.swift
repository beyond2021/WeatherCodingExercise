//
//  WeatherView.swift
//  WeatherTest
//
//  Created by KEEVIN MITCHELL on 9/13/24.
//

import SwiftUI
import CoreLocation

struct WeatherView: View{
    @AppStorage("lastCitySearched") var lastCitySearched: String = ""
    @AppStorage("freeToContinue") var freeToContinue: Bool = false
    @ObservedObject var viewModel: WeatherViewModel
    @State private var cityName: String = ""
    @FocusState private var isFocused: Bool
    @State private var locationManager: LocationManager = LocationManager()
    // Location
    var body: some View {
      //  NavigationView {
            ZStack{
                LinearGradient(colors: [.blue, .blue, .blue, .blue, .white, .blue], startPoint: .topTrailing, endPoint: .bottom).edgesIgnoringSafeArea([.top,.bottom])
                VStack {
//                    SearchView()
                    VerifiedSearch()
                        .padding(.bottom, 20)
                    WeatherDetailsView()
                    Spacer()
                }
                .onChange(of: freeToContinue, initial: false) {
                    if freeToContinue {
                        viewModel.fetchWeather(for: lastCitySearched)
                    }
                }
            }
            .navigationBarTitle(lastCitySearched + " Weather ✨", displayMode: .inline)
      //  }
        .onAppear {
            print(freeToContinue)
            viewModel.checkPermissionStatus()
            print(freeToContinue)
        }
        .onDisappear {
            lastCitySearched = viewModel.cityName
        }
    }
    
    @ViewBuilder
    private func WeatherDetailsView() -> some View {
        if let weatherData = viewModel.weatherData {
            VStack {
                AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weatherData.weather[0].icon)@2x.png")) { image in
                    image
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .accessibility(label: Text("Weather icon"))
                Text(viewModel.convertKelvinToFarhrenheit())
                    .font(.largeTitle)
                    .accessibility(label: Text("Temperature in Fahrenheit"))
                    .foregroundStyle(.white)
                Text(weatherData.weather[0].main.capitalized)
                    .font(.subheadline.bold())
                    .accessibility(label: Text("Weather description"))
                    .foregroundStyle(.white)
            }
            .padding()
        } else if let errorMessage = viewModel.errorMessage {
            Text(errorMessage)
                .foregroundColor(.red)
                .accessibility(label: Text("Error message"))
        }
    }
    @ViewBuilder
    private func SearchView() -> some View {
        VStack {
            HStack(spacing: 10){
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                TextField(NSLocalizedString("Enter a US city", comment: ""), text: $cityName, onCommit: {
                    
                    DispatchQueue.global().async {
                        if CLLocationManager.locationServicesEnabled() {
                            viewModel.fetchWeather(for: cityName)
                            lastCitySearched = cityName
                            isFocused = false
                        }
                    }
                    
                })
                
                .tint(.white)
            }
            .padding(.vertical,12)
            .padding(.horizontal, 15)
            .background{
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(.white)
            }
            .padding(.vertical,10)
            .padding(.horizontal)
        }
        
    }
    @ViewBuilder
    private func VerifiedSearch() -> some View {
        VStack {
                    TextField("Enter City Name", text: $viewModel.cityName)
                        .padding()
                        .border(viewModel.isCityNameValid ? Color.white : Color.red)
                        .accessibilityIdentifier("Enter City Name")
                        .onChange(of: viewModel.cityName, initial: false) {
                            viewModel.validateCityName() // Validate city name whenever it changes
                        }
                       
                    
                    if !viewModel.isCityNameValid, let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .accessibilityIdentifier("ErrorMessage")
                    }
                    
                    Button("Search") {
                        lastCitySearched = viewModel.cityName
                        viewModel.fetchWeather(for: viewModel.cityName)
                        isFocused = false
                    }
                    .padding()
                    .disabled(!viewModel.isCityNameValid) // Disable button if the input is invalid
                    .accessibilityIdentifier("Search")
                    .foregroundStyle(Color.white)
                }
        .offset(y: 20)
        .padding(.horizontal, 10)
    }
}



#Preview {
    
}

/*
 VStack {
            TextField("Enter City Name", text: $viewModel.cityName)
                .padding()
                .border(viewModel.isCityNameValid ? Color.gray : Color.red)
                .accessibilityIdentifier("Enter City Name")
                .onChange(of: viewModel.cityName) { _ in
                    viewModel.validateCityName() // Validate city name whenever it changes
                }
            
            if !viewModel.isCityNameValid, let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .accessibilityIdentifier("ErrorMessage")
            }
            
            Button("Search") {
                viewModel.searchWeather()
            }
            .padding()
            .disabled(!viewModel.isCityNameValid) // Disable button if the input is invalid
            .accessibilityIdentifier("Search")
        }
        .padding()
 */
