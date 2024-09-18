//
//  AppCoordinator.swift
//  WeatherTest
//
//  Created by KEEVIN MITCHELL on 9/13/24.
//

import UIKit
import SwiftUI

class AppCoordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let weatherService = WeatherService() // Inject the real service here.
        let viewModel = WeatherViewModel(weatherService: weatherService)
        let weatherView = WeatherView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: weatherView)
        navigationController.pushViewController(hostingController, animated: true)
    }
}
