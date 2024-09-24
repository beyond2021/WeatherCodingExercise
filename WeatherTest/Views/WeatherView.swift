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
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [.blue, .blue, .blue, .blue, .white, .blue], startPoint: .topTrailing, endPoint: .bottom).edgesIgnoringSafeArea([.top,.bottom])
            VStack {
                //                    SearchView()
                VerifiedSearch()
                    .padding(.bottom, 20)
                if viewModel.isCityNameValid || freeToContinue{
                    withAnimation(.easeInOut) {
                        WeatherDetailsView()
                    }
                } else {
                    WeatherDetailsView().opacity(0.0)
                }
                Spacer()
            }
            .padding(.top, 20)
            .onChange(of: freeToContinue, initial: false) {
                if freeToContinue {
                    viewModel.fetchWeather(for: viewModel.isCityNameValid ? lastCitySearched :  "Miami")//TODO
                }
            }
        }
        .navigationBarTitle(viewModel.navigationTitle, displayMode: .inline)
        
        .floatingBottomSheet(isPresented: $viewModel.showErrorAlert) {
            SheetView(
                title: "Ooops!",
                content: viewModel.errorMessage ?? NSLocalizedString("Unknown error", comment: ""),
                image: .init(
                    content: "exclamationmark.triangle.fill",
                    tint: .red,
                    foreground: .white
                ),
                button1: .init(
                    content: "OK",
                    tint: .red,
                    foreground: .white,
                    action: {
                        viewModel.isCityNameValid = true
                        viewModel.showErrorAlert = false
                    }
                )
            )
            .presentationDetents([.height(280)])
            .interactiveDismissDisabled()
        }
        .onAppear {
            viewModel.checkPermissionStatus()
            viewModel.isCityNameValid = true
            viewModel.showErrorAlert = false
            viewModel.navigationTitle = lastCitySearched + " Weather ✨"
        }
        .onDisappear {
            lastCitySearched = (viewModel.isCityNameValid ? lastCitySearched :  "Miami")//TODO
            
        }
    }
    @ViewBuilder
    private func WeatherDetailsView() -> some View {
        
        if let weatherData = viewModel.weatherData {
            VStack {
                AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weatherData.weather.first?.icon ?? "01d")@2x.png")) { image in
                    image
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .accessibility(label: Text("Weather icon"))
                Text(viewModel.kelvinToFahrenheitString())
                    .font(.system(size: 80))
                   // .font(.largeTitle)
                    .accessibility(label: Text("Temperature in Fahrenheit"))
                    .foregroundStyle(.white)
                Text(weatherData.weather[0].main.capitalized)
                    .font(.subheadline.bold())
                    .accessibility(label: Text("Weather description"))
                    .foregroundStyle(.white)
                Text(weatherData.weather[0].description.capitalized)
                    .font(.subheadline.bold())
                    .accessibility(label: Text("Weather description"))
                    .foregroundStyle(.white)
                Text("Visibility: \(weatherData.visibility)ft.")
                    .font(.subheadline.bold())
                    .accessibility(label: Text("Weather description"))
                    .foregroundStyle(.white)
            }
            .padding(.top, -40)
        } else if let _ = viewModel.errorMessage {
            Text("Please enter a valid US city.")
                .foregroundColor(.white)
                .accessibility(label: Text("Error message"))
        }
    }
    @ViewBuilder
    private func VerifiedSearch() -> some View {
        VStack {
            HStack {
                TextField(NSLocalizedString("Enter a US city", comment: ""), text: $viewModel.cityName)
                    .padding()
                    .accessibilityIdentifier("Enter City Name")
                    .onChange(of: viewModel.cityName, initial: false) {
                        viewModel.validateCityName() // Validate city name whenever it changes
                    }
                    .focused($isFocused)
                    .background{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .strokeBorder(viewModel.isCityNameValid ? Color.white : Color.red)
                    }
                    .padding(.vertical,10)
                if !viewModel.cityName.isEmpty {
                    Button {
                        withAnimation(.easeOut) {
                            viewModel.cityName = ""
                        }
                    }label: {
                        Image(systemName: "multiply.circle.fill")
                            .tint(.white)
                    }
                    .padding(.trailing, 10)
                }
            }
            if !viewModel.isCityNameValid, let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.gray)
                    .font(.callout).bold()
                    .accessibilityIdentifier("ErrorMessage")
            }
            Button("Search") {
                lastCitySearched = viewModel.cityName
                viewModel.fetchWeather(for: viewModel.cityName)
                viewModel.navigationTitle = lastCitySearched + " Weather ✨"
                viewModel.cityName = ""
                isFocused = false
            }
            .padding()
            .disabled(!viewModel.isCityNameValid || viewModel.cityName == "") // Disable button if the input is invalid
            .accessibilityIdentifier("Search")
            .foregroundStyle(Color.white)
            .opacity(!viewModel.isCityNameValid || viewModel.cityName == "" ? 0 : 1)
        }
        .offset(y: 20)
        .padding(.horizontal, 10)
    }
}
