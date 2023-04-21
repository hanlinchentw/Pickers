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
		(Bundle.main.infoDictionary?["YELP_BACKEND_URL"] as! String)
								.replacingOccurrences(of: "\\", with: "")
	}
	
	static var apiKey: String {
		(Bundle.main.infoDictionary?["YELP_API_KEY"] as! String)
			.replacingOccurrences(of: "\\", with: "")
	}
	
	static var googleMapApiKey: String {
		(Bundle.main.infoDictionary?["GOOGLE_MAP_API_KEY"] as! String)
			.replacingOccurrences(of: "\\", with: "")
	}
}
