//
//  RestaurantAPI.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/10/6.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import Foundation

public protocol RestaurantAPI: AnyObject{
    func pushToDetailVC(_ restaurant: Restaurant)
    func didSelectRestaurant(restaurant:Restaurant)
    func didLikeRestaurant(restaurant:Restaurant)
}
extension RestaurantAPI {
    func pushToDetailVC(_ restaurant: Restaurant) {}
}
