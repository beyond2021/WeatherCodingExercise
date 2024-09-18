//
//  AsyncImageViewModel.swift
//  WeatherTest
//
//  Created by KEEVIN MITCHELL on 9/17/24.
//

import Foundation
import UIKit
class AsyncImageViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading: Bool = false
    private let url: URL
    private let imageLoader = AsyncImageLoader()

    init(url: URL) {
        self.url = url
    }

    func loadImage() {
        isLoading = true
        Task {
            do {
                let loadedImage = try await imageLoader.loadImage(from: url)
                await MainActor.run {
                    self.image = loadedImage
                    self.isLoading = false
                }
            } catch {
                print("Failed to load image: \(error)")
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
}




