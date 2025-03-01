//
//  YelpPlaceRequest.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/1/6.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import APIKit
import Foundation

struct YelpPlaceRequest: Request {
  enum EndPoint {
    case search
    case detail(id: String)
  }

  let endPoint: EndPoint
  var queryParameter: [String: String] = [:]

  var baseURL: URL {
    URL(string: Configuration.yelpBaseURL)!
  }

  var path: String {
    switch endPoint {
    case .search:
      "/v3/businesses/search"
    case let .detail(id):
      "/v3/businesses/\(id)"
    }
  }

  var method: HTTPMethod {
    .get
  }

  var httpHeaders: [String: String] {
    [
      "accept": "application/json",
      "Authorization": "Bearer \(Configuration.yelpApiKey)"
    ]
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
