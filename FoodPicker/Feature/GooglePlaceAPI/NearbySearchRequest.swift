//
//  NearbySearchRequest.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/21.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation
import APIKit

/*
 https://maps.googleapis.com/maps/api/place/nearbysearch/json
 ?keyword=cruise
 &location=-33.8670522%2C151.1957362
 &radius=1500
 &type=restaurant
 &key=YOUR_API_KEY
 */

struct NearbySearchRequest: Request {
	var keyword: String
	var latitude: Double
	var longitude: Double
	
	typealias Response = PlaceApiResponse
	
	var baseURL: URL {
		URL(string: Configuration.googlePlaceApiBaseURL)!
	}
	
	var method: APIKit.HTTPMethod {
		.get
	}
	
	var path: String {
		"/nearbysearch/json"
	}
	
	var queryParameters: [String : Any]? {
		[
			"keyword": keyword,
			"location": "\(latitude),\(longitude)",
			"radius": 5000,
			"type": "Restaurant",
			"key": Configuration.googleMapApiKey,
		]
	}
	
	func response(from object: Any, urlResponse: HTTPURLResponse) throws -> PlaceApiResponse {
		guard let result = object as? PlaceApiResponse else {
			throw ResponseError.unexpectedObject(object)
		}
		
		return result
	}
}
