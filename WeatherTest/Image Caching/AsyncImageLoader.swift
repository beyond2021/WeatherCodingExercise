//
//  AsyncImageLoader.swift
//  WeatherTest
//
//  Created by KEEVIN MITCHELL on 9/17/24.
//

import SwiftUI

import SwiftUI

actor AsyncImageLoader {
    private let cache = ImageCacheManager.shared
    
    func loadImage(from url: URL) async throws -> UIImage {
        let urlString = url.absoluteString
        
        // Check if the image is already in the cache
        if let cachedImage = cache.getCachedImage(forKey: urlString) {
            return cachedImage
        }
        
        // Download the image
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }
        
        // Cache the downloaded image
        cache.cacheImage(image, forKey: urlString)
        return image
    }
}

