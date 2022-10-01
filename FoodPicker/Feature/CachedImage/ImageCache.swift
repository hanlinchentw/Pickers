//
//  ImageCache.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/10/1.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

protocol ImageCache {
	typealias CacheType = NSCache<NSString, NSData>
	
	var cache: CacheType { get }
	
	func get(forKey key: NSString) -> Data?

	func set(object: NSData, forKey key: NSString)
}

extension ImageCache {
	func get(forKey key: NSString) -> Data? {
		return cache.object(forKey: key) as? Data
	}

	func set(object: NSData, forKey key: NSString) {
		cache.setObject(object, forKey: key)
	}
}
