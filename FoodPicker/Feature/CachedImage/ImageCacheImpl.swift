//
//  ImageCache.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/23.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

class ImageCacheImpl: ImageCache {
  static let shared = ImageCacheImpl()

  private(set) lazy var cache: CacheType = {
    let cache = CacheType()
    cache.countLimit = 100
    cache.totalCostLimit = 50 * 1024 * 1024
    return cache
  }()
}

