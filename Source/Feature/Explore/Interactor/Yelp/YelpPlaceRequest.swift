//
//  YelpPlaceRequest.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/1/6.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import APIKit
import Foundation
import URL

struct YelpPlaceRequest: Request {
  enum EndPoint {
    case search
    case detail(id: String)
  }

  let endPoint: EndPoint

	var customQueryParameter: [String: Any] = [:]

	var queryParameters: [String: Any]? {
		customQueryParameter
	}

  var baseURL: URL {
		Configuration.yelpBaseURL
  }

  var path: String {
    switch endPoint {
    case .search:
      "/businesses/search"
    case let .detail(id):
      "/businesses/\(id)"
    }
  }

  var method: HTTPMethod {
    .get
  }

	var headerFields: [String: String] {
		["Authorization": "Bearer \(Configuration.yelpApiKey)"]
	}

  var timeout: TimeInterval? {
    5
  }

  var jsonDecoder: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }
}
