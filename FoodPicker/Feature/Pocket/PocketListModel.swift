//
//  PocketList.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/30.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation

struct PocketListModel<T> {
	var id: String
	var name: String
	var items: [T]
}
