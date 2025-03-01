//
//  URLCache+Extensions.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/23.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

extension URLCache {
  static let imageCache = URLCache(memoryCapacity: 512 * 1000 * 1000, diskCapacity: 10 * 1000 * 1000 * 1000)
}
