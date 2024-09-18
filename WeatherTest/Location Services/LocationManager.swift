//
//  LocationManager.swift
//  WeatherTest
//
//  Created by KEEVIN MITCHELL on 9/16/24.
//
import Foundation
import CoreLocation
import SwiftUI

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @AppStorage("freeToContinue") var freeToContinue: Bool = false
    private let locationManager = CLLocationManager()
    func checkIfLocationServicesIsEnabled(){
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled(){
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest/// kCLLocationAccuracyBest is the default
                self.checkLocationAuthorization()
            }else{
                //TODO  show message: Services desabled!
            }
        }
    }
    private func checkLocationAuthorization(){
        switch locationManager.authorizationStatus{
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            freeToContinue = false
        case .restricted:
            freeToContinue = false
            print("DEBUG: Location Services are restricted")
        case .denied:
            freeToContinue = false
            print("DEBUG: Location Services are denied")
        case .authorizedWhenInUse, .authorizedAlways:
            /// app is authorized
            print("DEBUG: Location Successful")
            locationManager.startUpdatingLocation()
            freeToContinue = true
        default:
            break
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
