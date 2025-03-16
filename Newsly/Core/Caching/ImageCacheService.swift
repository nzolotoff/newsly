//
//  ImageCacheService.swift
//  Newsly
//
//  Created by Nikita Zolotov on 15.03.2025.
//

import Foundation
import UIKit

final class ImageCacheService {
    // MARK: - Constants
    enum Constants {
        static let countLimit: Int = 100
        static let queueLabel: String = "com.newsapp.imagecache"
    }
    // MARK: - Singleton
    static let shared: ImageCacheService = ImageCacheService()
    
    private init() {
        cache.countLimit = Constants.countLimit
    }
    
    // MARK: - Fields
    private let cache = NSCache<NSString, UIImage>()
    private let queue = DispatchQueue(label: Constants.queueLabel)
    
    // MARK: - CRUD Methods
    func set(image: UIImage, for key: String) {
        queue.async { [weak self] in
            self?.cache.setObject(image, forKey: key as NSString)
        }
    }
    
    func getImage(for key: String) -> UIImage? {
        queue.sync { [weak self] in
            self?.cache.object(forKey: key as NSString)
        }
    }
    
    func clearCache() {
        queue.async {  [weak self] in
            self?.cache.removeAllObjects()
        }
    }
}
