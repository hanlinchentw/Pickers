//
//  PlaceListViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/27.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation

struct PlaceViewModel {
	var id: String
	var name: String
	var price: String?
	var rating: Double?
	var reviewCount: Int?
	var businessCategory: String?
	var imageUrls: [URL?] = []
	var latitude: Double
	var longitude: Double
	var isClosed: Bool
	var isSelected: Bool
}
