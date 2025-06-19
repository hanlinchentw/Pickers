//
//  Config.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/3/30.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation
import URL

// swiftlint:disable force_cast
final class Configuration {
	static var yelpBaseURL: URL {
		#URL("https://api.yelp.com/v3")
  }

  static var googlePlaceApiBaseURL: String {
    ""
  }

  static var googleMapApiKey: String {
    ""
  }

  static var yelpApiKey: String {
    getBundleValueByKey("YELP_API_KEY")
  }

  static func getBundleValueByKey(_ key: String) -> String {
    (Bundle.main.infoDictionary?[key] as! String)
      .replacingOccurrences(of: "\\", with: "")
  }
}

// swiftlint:enable force_cast
