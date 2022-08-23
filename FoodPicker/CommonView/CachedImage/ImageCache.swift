//
//  ImageCache.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/23.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

class ImageCache {
  static let shared = ImageCache()

  typealias CacheType = NSCache<NSString, NSData>

  private lazy var cache: CacheType = {
    let cache = CacheType()
    cache.countLimit = 100
    cache.totalCostLimit = 50 * 1024 * 1024
    return cache
  }()

  func object(forKey key: NSString) -> Data? {
    return cache.object(forKey: key) as? Data
  }

  func set(object: NSData, forKey key: NSString) {
    cache.setObject(object, forKey: key)
  }
}
