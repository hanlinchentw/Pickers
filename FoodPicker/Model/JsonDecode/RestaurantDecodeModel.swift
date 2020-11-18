//
//  RestaurantDecodeModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/11/17.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import Foundation
import CoreLocation
//MARK: - Detail
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
//MARK: -  Business
struct Root : Decodable{
    let businesses : [Business]
}

struct Business : Decodable {
    let id : String
    let name : String
    let rating : Double
    let price : String
    let imageUrl : String
    let distance : Double
    let isClosed : Bool
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
