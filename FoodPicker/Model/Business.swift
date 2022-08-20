//
//  RestaurantDecodeModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/11/17.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import Foundation
import CoreLocation

struct Root : Decodable{
    let businesses : [Business]
}

struct Business: Decodable {
    let id : String
    let name : String
    let rating : Double
    let price : String?
    let imageUrl : String?
    let distance : Double?
    let isClosed : Bool?
    let categories : [Categories]
    let reviewCount : Int
    let coordinates : CLLocationCoordinate2D
}

struct Categories : Codable{
    let title : String
}
extension CLLocationCoordinate2D: Decodable{
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