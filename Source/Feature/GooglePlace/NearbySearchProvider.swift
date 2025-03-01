//
//  NearbySearchProvider.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/22.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import APIKit
import Foundation

protocol NearbySearchProvider {
  func search(keyword: String, latitude: Double, longitude: Double) async throws -> [PlaceApiResult]
}

final class NearbySearchProviderImpl: NearbySearchProvider {
  func search(keyword: String, latitude: Double, longitude: Double) async throws -> [PlaceApiResult] {
    let request = NearbySearchRequest(keyword: keyword, latitude: latitude, longitude: longitude)
    let response = try await Session.response(for: request)
    return response.results
  }
}
