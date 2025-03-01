//
//  YelpPlaceRequestBuilder.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/1/6.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import Foundation

final class YelpPlaceRequestBuilder {
  enum Query {
    case coordinate(Double, Double)
    case location(String)
    case sortBy(String)
    case term(String)
    case radius(Int)
    case limit(Int)
    case offset(Int)

    var codingKey: [String: String] {
      switch self {
      case let .coordinate(lat, lon):
        ["latitude": "\(lat)", "longitude": "\(lon)"]
      case let .limit(limit):
        ["limit": "\(limit)"]
      case let .location(location):
        ["location": location]
      case let .offset(offset):
        ["offset": "\(offset)"]
      case let .radius(radius):
        ["radius": "\(radius)"]
      case let .sortBy(sortBy):
        ["sory_by": sortBy]
      case let .term(term):
        ["term": term]
      }
    }
  }

  let endPoint: YelpPlaceRequest.EndPoint
  var queryParameters = [String: String]()

  init(endPoint: YelpPlaceRequest.EndPoint) {
    self.endPoint = endPoint
  }

  func addQuery(_ query: Query) -> YelpPlaceRequestBuilder {
    queryParameters.merge(query.codingKey, uniquingKeysWith: { $1 })
    return self
  }

  func build() -> YelpPlaceRequest {
    var request = YelpPlaceRequest(endPoint: endPoint)
    request.queryParameter = queryParameters
    return request
  }
}
