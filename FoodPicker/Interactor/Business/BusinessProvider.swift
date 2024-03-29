//
//  YelpService.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/3.
//  Copyright © 2021 陳翰霖. All rights reserved.ㄐ
//

import Alamofire

enum BusinessProvider: NetworkProvider {
  case search(_ lat: Double, _ lon: Double,
              category: String = "restaurant",
              sortBy : String,
              offset: Int = 0,
              limit: Int)

	case searchByTerm(lat:Double, lon: Double, term: String, offset: Int = 0)

  case detail(id: String)

	var baseURL: String { Configuration.baseURL + "/businesses" }

	var headers: HTTPHeaders? { return ["Authorization":"Bearer \(Configuration.apiKey)"]}

  var method: HTTPMethod { HTTPMethod.get }

  var path: String {
    switch self {
    case .searchByTerm: return "/search"
    case .search: return "/search"
    case let .detail(id): return "/\(id)"
    }
  }

  var parameters: [String: Any] {
    switch self {
    case let .search(lat, lon, category, sortBy, offset, limit):
      return [
				"categories": category,
				"latitude": lat,
				"longitude": lon,
				"radius": 3000,
				"sort_by": sortBy,
				"limit": limit,
				"offset": offset
			]

    case let .searchByTerm(lat, lon, term, offset):
      return [
				"term": term,
				"latitude": lat,
				"longitude": lon,
				"categories": "restaurant",
				"limit" : 50,
				"offset": offset]

    case .detail:
			return [:]
    }
  }
}
