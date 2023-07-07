//
//  PhotoRequest.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/7/3.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

/*
https://maps.googleapis.com/maps/api/place/photo
	?maxwidth=400
	&photo_reference=Aap_uEA7vb0DDYVJWEaX3O-AtYp77AaswQKSGtDaimt3gt7QCNpdjp1BkdM6acJ96xTec3tsV_ZJNL_JP-lqsVxydG3nh739RE_hepOOL05tfJh2_ranjMadb3VoBYFvF0ma6S24qZ6QJUuV6sSRrhCskSBP5C1myCzsebztMfGvm7ij3gZT
	&key=YOUR_API_KEY
*/
import APIKit

struct PhotoRequest: Request {
	let reference: String
	
	typealias Response = Data
	
	var baseURL: URL {
		URL(string: Configuration.googlePlaceApiBaseURL)!
	}
	
	var method: APIKit.HTTPMethod {
		.get
	}
	
	var path: String {
		"/photo"
	}
	
	var url: URL? {
		try? self.buildURLRequest().url
	}

	var queryParameters: [String : Any]? {
		[
			"maxwidth": 400,
			"photo_reference": reference,
			"key": Configuration.googleMapApiKey,
		]
	}

	func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Data {
		guard let object = object as? Data else {
			throw CastError(actualValue: object, expectedType: Data.self)
		}
		return object
	}
}
