//
//  Restaurant.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/12.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import CoreLocation

struct Restaurant {
    let restaurantID : String
    let name: String
    let type : String
    let rating : Double
    let isClosed : Bool
    let imageUrl : URL
    let distance : Double
    let reviewCount : Int
    let price : String
    let location : CLLocationCoordinate2D
    
    var isSelected : Bool = false
    var isLiked : Bool = false
    
    
    var filterOption : FilterOptions?
    
    init(business:Business) {
        self.restaurantID = business.id
        self.name = business.name
        self.imageUrl = business.imageUrl
        self.distance = business.distance

        
        self.rating = business.rating
        self.isClosed = business.isClosed
        self.reviewCount = business.reviewCount
        self.type = business.categories[0].title
        self.price = business.price ?? "$"
        self.location = business.coordinates
    }
}

struct Details : Decodable {
    let price : String?
    let rating : Double
    let photos : [URL]?
    let isClosed : Bool
    let categories : [categories]
    let reviewCount : Int
    let coordinates : CLLocationCoordinate2D
    let transactions : [String]
}

struct Root : Decodable{
    let businesses : [Business]
}

struct Business : Decodable {
    let id : String
    let name : String
    let rating : Double
    let price : String?
    let imageUrl : URL
    let distance : Double
    let isClosed : Bool
    let categories : [categories]
    let reviewCount : Int
    let coordinates : CLLocationCoordinate2D
}

struct categories : Codable{
    let title : String
}

extension CLLocationCoordinate2D : Decodable {
    enum CodingKeys : CodingKey {
        case latitude
        case longitude
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let lat = try container.decode(Double.self, forKey: .latitude)
        let lon = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude:lat, longitude:lon)
    }
}
