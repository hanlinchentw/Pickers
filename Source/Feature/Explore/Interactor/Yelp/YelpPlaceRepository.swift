//
//  YelpPlaceRepository.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/10/5.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import Foundation

final class PlaceRepositoryImpl: PlaceRepository {
  let restClient: RestClient

  private(set) var currentPage = 0
  private(set) var hasMoreToLoad = true
  private(set) var isLoading = false

  init(restClient: RestClient) {
    self.restClient = restClient
  }

  func fetch(config: PlaceSearchConfig) async throws -> [Business] {
    let location = config.location
    isLoading = true
    defer { isLoading = false }

    let lat = location.latitude
    let lon = location.longitude
    let request = YelpPlaceRequestBuilder(endPoint: .search)
      .addQuery(.coordinate(lat, lon))
      .addQuery(.limit(20))
      .addQuery(.offset(0))
      .addQuery(.term("food"))
      .build()
    let task: Task<Root, Error> = Task { try await restClient.execute(request) }
    let result: Root = try await task.value
    hasMoreToLoad = result.businesses.count == 20
    return result.businesses
  }

  func fetchMore(config: PlaceSearchConfig) async throws -> [Business] {
    let location = config.location
    isLoading = true
    defer { isLoading = false }

    let lat = location.latitude
    let lon = location.longitude
    currentPage += 1
    let request = YelpPlaceRequestBuilder(endPoint: .search)
      .addQuery(.coordinate(lat, lon))
      .addQuery(.limit(20))
      .addQuery(.offset(currentPage))
      .addQuery(.term("food"))
      .build()
    let task: Task<Root, Error> = Task { try await restClient.execute(request) }
    let result: Root = try await task.value
    hasMoreToLoad = result.businesses.count == 20
    return result.businesses
  }
}
