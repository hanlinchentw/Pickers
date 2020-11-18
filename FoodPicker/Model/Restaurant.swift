//
//  Restaurant.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/12.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import Foundation
import CoreLocation

let defaultImageURL =  "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=3150&q=80)"

struct Restaurant {
    let restaurantID : String
    let name: String
    let type : String
    let rating : Double
    let isClosed : Bool?
    let imageUrl : URL
    let distance : Double
    let reviewCount : Int
    let price : String
    let coordinates : CLLocationCoordinate2D
    let categories : [Categories]
    var details : Details?
    
    var isSelected : Bool = false
    var isLiked : Bool = false
    var numOfLike : Int = 0
    var division: String = "All restaurants"
    
    init(business:Business?, detail: Details? = nil) {
        if let detail = detail {
            self.details = detail
            self.restaurantID = detail.id
            self.name = detail.name
            self.imageUrl = detail.imageUrl ?? URL(string:defaultImageURL)!
            self.distance = 0
            self.rating = detail.rating
            self.isClosed = detail.isClosed
            self.reviewCount = detail.reviewCount
            self.price = detail.price ?? "$"
            
            self.coordinates = CLLocationCoordinate2D(latitude: detail.coordinates.latitude,
                                                      longitude: detail.coordinates.longitude)
            self.categories = detail.categories
            guard !detail.categories.isEmpty else {
                self.type = "Food"
                return
            }
            self.type = detail.categories[0].title
        }else{
            self.restaurantID = business!.id
            self.name = business!.name
            self.imageUrl = URL(string:business!.imageUrl)!
            
            self.distance = business!.distance
            
            self.rating = business!.rating
            self.isClosed = business!.isClosed
            self.reviewCount = business!.reviewCount
            self.price = business!.price
            self.coordinates = business!.coordinates
            self.categories = business!.categories
            guard !business!.categories.isEmpty else {
                self.type = "Food"
                return
            }
            self.type = business!.categories[0].title
        }
    }
}



