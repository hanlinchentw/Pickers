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

struct Business: Codable {
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

struct Categories : Codable {
	let title : String
}

extension CLLocationCoordinate2D: Codable {

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
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(latitude, forKey: .latitude)
		try container.encode(longitude, forKey: .longitude)
	}
}

extension Business: Equatable {
	static func == (lhs: Business, rhs: Business) -> Bool {
		lhs.id == rhs.id
	}
	
}
