//
//  GoogleProvider.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/29.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import Alamofire


/*
 NearBy API Ref:
 https://developers.google.com/maps/documentation/places/web-service/search-nearby#maps_http_places_nearbysearch-txt
 example
 https://maps.googleapis.com/maps/api/place/nearbysearch/json
 ?keyword=restaurant
 &location=-33.8670522%2C151.1957362
 &radius=1500
 &type=restaurant
 &key=API_KEY
 */
enum GoogleProvider: NetworkProvider {
	case nearby(_ lat: Double, _ lon: Double,
							keyword: String = "restaurant",
							rankBy: String
	)
	
	var baseURL: String {
		"https://maps.googleapis.com/maps/api/place"
	}
	
		var headers: HTTPHeaders? { return ["Authorization":"Bearer \(Constants.GOOGLE_PLACE_API_KEY)"]}
	
	var method: HTTPMethod { HTTPMethod.get }
	
	var path: String {
		switch self {
		case .nearby: return "/nearbysearch/json"
		}
	}
	
	var parameters: [String: Any] {
		switch self {
		case let .nearby(lat, lon, keyword, rankby):
			return [
				"keyword": keyword,
				"location": "\(lat)%2C\(lon)",
				"rankby": rankby,
				"type": "restaurant"
			]
		}
	}
}

