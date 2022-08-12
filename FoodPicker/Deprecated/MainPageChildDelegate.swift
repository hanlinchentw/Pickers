////
////  MainPageChildDelegate.swift
////  FoodPicker
////
////  Created by 陳翰霖 on 2021/10/6.
////  Copyright © 2021 陳翰霖. All rights reserved.
////
//
//import Foundation
//
//public protocol MainPageChildControllersDelegate: RestaurantAPI {
////    var restaurants: RestaurantsFiltered? { get set }
////    func updateRestaurantSelectStatus(restaurants: inout [Restaurant], restaurantID: String,
////                                      shouldSelect: Bool) -> [Restaurant]
////    func updateRestaurantLikeStatus(restaurants: inout [Restaurant], restaurantID: String,
////                                    shouldLike: Bool) -> [Restaurant]
//}
////
////extension MainPageChildControllersDelegate {
////    func updateRestaurantSelectStatus(restaurants: inout [Restaurant], restaurantID: String,
////                                      shouldSelect: Bool) -> [Restaurant] {
////        if let index = restaurants.firstIndex(where: { $0.restaurantID == restaurantID}) {
////            restaurants[index].isSelected = shouldSelect
////            return restaurants
////        }
////        return restaurants
////    }
////    func updateRestaurantLikeStatus(restaurants: inout [Restaurant], restaurantID: String,
////                                    shouldLike: Bool) -> [Restaurant] {
////        if let index = restaurants.firstIndex(where: { $0.restaurantID == restaurantID}) {
////            restaurants[index].isLiked = shouldLike
////            return restaurants
////        }
////        return restaurants
////    }
////}
