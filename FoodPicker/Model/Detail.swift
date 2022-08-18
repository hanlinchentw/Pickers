//
//  Details.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/8.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import CoreLocation

struct Detail : Decodable {
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
