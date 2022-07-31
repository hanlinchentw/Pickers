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
    let rating : Double
    let isClosed : Bool?
    let imageUrl : URL
    let reviewCount : Int
    let price : String
    let coordinates : CLLocationCoordinate2D
    let categories : String

    var numOfLike : Int = 0
//    var details : Details?

//    var isSelected : Bool = false
//    var isLiked : Bool = false
//    var category: recommendOption? = .all
//    var distance : Double {
//        guard let loacation = LocationHandler.shared.locationManager.location else { return 0 }
//        let restaurantLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
//        return loacation.distance(from: restaurantLocation)
//    }
    
    init(business: Business) {
      self.restaurantID = business.id
      self.name = business.name
      self.imageUrl = URL(string: business.imageUrl) ?? URL(string: defaultImageURL)!
      self.rating = business.rating
      self.isClosed = business.isClosed
      self.reviewCount = business.reviewCount
      self.price = business.price ?? "$"
      self.coordinates = business.coordinates
      self.categories = business.categories[0].title
    }
}



