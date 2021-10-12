//
//  RestaurantsFiltered.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/10/6.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import Foundation

public struct RestaurantsFiltered {
    var restaurants: [Restaurant]
    let filterOption: recommendOption
    
    func prefix(to num: Int) -> [Restaurant] {
        return Array(restaurants.prefix(num))
    }
}
