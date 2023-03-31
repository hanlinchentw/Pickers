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
		(Bundle.main.infoDictionary?["BACKEND_URL"] as! String)
								.replacingOccurrences(of: "\\", with: "")
	}
	
	static var apiKey: String {
		(Bundle.main.infoDictionary?["API_KEY"] as! String)
			.replacingOccurrences(of: "\\", with: "")
	}
}
