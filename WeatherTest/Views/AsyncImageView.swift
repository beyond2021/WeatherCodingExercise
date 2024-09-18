//
//  AsyncImageView.swift
//  WeatherTest
//
//  Created by KEEVIN MITCHELL on 9/17/24.
//

import SwiftUI

struct AsyncImageView: View {
    @StateObject private var viewModel: AsyncImageViewModel

    init(url: URL) {
        _viewModel = StateObject(wrappedValue: AsyncImageViewModel(url: url))
    }

    var body: some View {
        Group {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if viewModel.isLoading {
                ProgressView() // Show a loading indicator while the image is loading
            } else {
                Image(systemName: "photo") // Fallback image
                    .resizable()
                    .scaledToFit()
            }
        }
        .onAppear {
            viewModel.loadImage()
        }
    }
}


