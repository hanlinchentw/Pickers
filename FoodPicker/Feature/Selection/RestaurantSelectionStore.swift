//
//  RestaurantSelectionStore.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/7/21.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation

class RestaurantSelectionStore: ObservableObject {
	@Published var selectedRestaurants: [RestaurantSelectionDomainModel] = []
}
