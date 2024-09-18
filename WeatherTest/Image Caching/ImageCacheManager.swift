//
//  ImageCacheManager.swift
//  WeatherTest
//
//  Created by KEEVIN MITCHELL on 9/17/24.
// Singleton Pattern

import SwiftUI
class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private let cache = NSCache<NSString, UIImage>()

    private init() {}
    
    // MARK: - Get Cached Image
    func getCachedImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    // MARK: - Cache Image
    func cacheImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}
