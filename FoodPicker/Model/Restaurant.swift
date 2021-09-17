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
    
    var details : Details?
    
    var isSelected : Bool = false
    var isLiked : Bool = false
    var numOfLike : Int = 0
    var division: String = "All restaurants"
    var distance : Double {
        guard let loacation = LocationHandler.shared.locationManager.location else { return 0 }
        let restaurantLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        return loacation.distance(from: restaurantLocation)
    }
    
    init(business:Business?, detail: Details? = nil, dictionary: [String : Any]? = nil ) {
        if let detail = detail {
            self.details = detail
            self.restaurantID = detail.id ?? ""
            self.name = detail.name ?? "Not found"
            self.imageUrl = detail.imageUrl ?? URL(string:defaultImageURL)!
            self.rating = detail.rating
            self.isClosed = detail.isClosed
            self.reviewCount = detail.reviewCount
            self.price = detail.price ?? "$"
            self.coordinates = CLLocationCoordinate2D(latitude: detail.coordinates.latitude,
                                                      longitude: detail.coordinates.longitude)
            self.categories = detail.categories[0].title
        }else if let dict = dictionary{
            self.restaurantID = dict["id"] as? String ?? "Not found"
            self.name = dict["name"] as? String ?? "Not found"
            self.imageUrl = dict["imageUrl"] as? URL ?? URL(string: defaultImageURL)!
            self.rating = dict["rating"] as? Double ?? 5.0
            self.reviewCount = dict["reviewCount"] as? Int ?? 0
            self.price = dict["price"] as? String ?? "$"
            self.coordinates = dict["coordinate"] as? CLLocationCoordinate2D ?? CLLocationCoordinate2D(latitude: 23, longitude: 121)
            self.categories = dict["category"] as? String ?? "Food"
            self.isClosed = false
        }else{
            self.restaurantID = business!.id
            self.name = business!.name
            self.imageUrl = URL(string:business!.imageUrl) ?? URL(string: defaultImageURL)!
            self.rating = business!.rating
            self.isClosed = business!.isClosed
            self.reviewCount = business!.reviewCount
            self.price = business!.price ?? "$"
            self.coordinates = business!.coordinates
            guard let boo = business!.categories[safe: 0] else {
                self.categories = "Cuisine"
                return
            }
            self.categories = boo.title
        }
        
    }
}



