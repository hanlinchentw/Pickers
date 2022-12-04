//
//  Query.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/30.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

struct Query {
	var searchText: String?
	var lat: Double
	var lon: Double
	var option: SearchOption?
	var limit: Int?
	var offset: Int?
}

extension Query {
	static var dummyQuery: Query {
		.init(lat: 24.9, lon: 121.3)
	}
}
