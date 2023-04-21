//
//  Config.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/3/30.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation

final class Configuration {
	static var baseURL: String {
		getBundleValueByKey("YELP_BACKEND_URL")
	}
	
	static var apiKey: String {
		getBundleValueByKey("YELP_API_KEY")
	}
	
	static var googleMapApiKey: String {
		getBundleValueByKey("GOOGLE_MAP_API_KEY")
	}
	
	static var googlePlaceApiBaseURL: String {
		return "https://maps.googleapis.com/maps/api/place"
	}
	
	static func getBundleValueByKey(_ key: String) -> String {
		(Bundle.main.infoDictionary?[key] as! String)
			.replacingOccurrences(of: "\\", with: "")
	}
}
