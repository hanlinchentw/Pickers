//
//  Restaurant.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/12.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import CoreLocation
let defaultImageURL = URL(string: "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=3150&q=80)")!
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
    var sortOption : SortOption?
    
    init(detail: Details?, business:Business?) {
        if let detail = detail {
            self.details = detail
            self.restaurantID = detail.id
            self.name = detail.name
            self.imageUrl = detail.imageUrl ?? defaultImageURL
            self.distance = 0

            
            self.rating = detail.rating
            self.isClosed = detail.isClosed
            self.reviewCount = detail.reviewCount
            self.price = detail.price ?? "$"
            self.coordinates = detail.coordinates
            self.categories = detail.categories
            guard !detail.categories.isEmpty else {
                self.type = "Food"
                return
            }
            self.type = detail.categories[0].title
        }else{
            self.restaurantID = business!.id
            self.name = business!.name
            self.imageUrl = URL(string:business!.imageUrl) ?? defaultImageURL
                
            self.distance = business!.distance

            
            self.rating = business!.rating
            self.isClosed = business!.isClosed
            self.reviewCount = business!.reviewCount
            self.price = business!.price ?? "$"
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

struct Details : Decodable {
    let displayPhone : String?
    let photos : [URL]?
    let hours : [Open]?
    let location : Address?
    
    let id : String
    let name: String
    let rating : Double
    let isClosed : Bool?
    let imageUrl : URL?
    let reviewCount : Int
    let price : String?
    let coordinates : CLLocationCoordinate2D
    let categories : [Categories]
}

struct Address : Decodable {
    let displayAddress : [String]
}

struct Open : Decodable {
    let open : [businessHour]
}
struct businessHour : Decodable {
    let start: String
    let end : String
    let day : Int
}


struct Root : Decodable{
    let businesses : [Business]
}

struct Business : Decodable {
    let id : String
    let name : String
    let rating : Double
    let price : String?
    let imageUrl : String
    let distance : Double
    let isClosed : Bool?
    let categories : [Categories]
    let reviewCount : Int
    let coordinates : CLLocationCoordinate2D
}

struct Categories : Codable{
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
