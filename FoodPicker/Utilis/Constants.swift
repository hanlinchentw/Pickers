//
//  Constants.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/9.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import Foundation
import Firebase

let searchHistoryEntityName = "SearchHistory"
let selectedEntityName = "SelectedRestaurant"
let likedEntityName = "LikedRestaurant"
let listEntityName = "ListEntity"
let savedRestaurantName = "SavedRestaurant"

let DID_SELECT_KEY = "restaurantDidSelect"
let DID_LIKE_KEY = "restaurantDidLike"
let categoryPreload = ["Coffee", "Bubble Tea", "Hamburger", "Pizza", "Korean", "Italian", "Chinese",
                       "Taiwanese","Japanese", "Thai"]

let DB_REF = Database.database().reference()

let REF_USER = DB_REF.child("user")
let REF_USER_LIKE = DB_REF.child("user-likes")
let REF_USER_SEARCH = DB_REF.child("user-search")
let REF_SEARCH = DB_REF.child("search")
let REF_RESTAURANT_LIKE = DB_REF.child("restaurant-like")
let REF_USER_LIST = DB_REF.child("user-lists")
