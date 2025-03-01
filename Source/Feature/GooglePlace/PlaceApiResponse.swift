//
//  PlaceApiResponse.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/21.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import CoreLocation
import Foundation

struct PlaceApiResponse: Decodable {
  let nextPageToken: String
  let results: [PlaceApiResult]
}

struct PlaceApiResult: Decodable {
  let placeId: String
  let businessStatus: String
  let name: String
  let rating: Double
  let geometry: Geometry
  let openingHours: OpeningHours
  let photos: [PlacePhoto]?

  struct Geometry: Decodable {
    let location: Location

    struct Location: Decodable {
      let lat: Double
      let lng: Double
    }
  }

  struct OpeningHours: Decodable {
    let openNow: Bool
  }

  struct PlacePhoto: Decodable {
    let photoReference: String
  }
}

extension PlaceApiResult: Equatable {
  static func == (lhs: PlaceApiResult, rhs: PlaceApiResult) -> Bool {
    lhs.placeId == rhs.placeId
  }
}

extension PlaceApiResult {
  static var staticData: [Self] {
    guard let data = StaticJsonFileReader.read("Place") else {
      return []
    }
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let response = try? decoder.decode(PlaceApiResponse.self, from: data)
    return response?.results ?? []
  }
}
