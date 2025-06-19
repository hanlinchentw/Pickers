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

	private let limit = 50
  private(set) var currentPage = 0
	private(set) var hasMoreToLoad = false
  private(set) var isLoading = false

  init(restClient: RestClient) {
    self.restClient = restClient
  }

	var baseRequest: YelpPlaceRequestBuilder {
		let language = Locale.current.language
		let code = language.languageCode == "zh" ? "zh_TW" : "en_US"
		return YelpPlaceRequestBuilder(endPoint: .search)
			.addQuery(.limit(limit))
			.addQuery(.offset(currentPage))
			.addQuery(.locale(code))
	}

	func fetch(config: PlaceSearchConfig) async throws -> [Business] {
		currentPage = 0
		return try await getBusinesses(config: config)
  }

  func fetchMore(config: PlaceSearchConfig) async throws -> [Business] {
		currentPage += 1
		return try await getBusinesses(config: config)
  }

	private func getBusinesses(config: PlaceSearchConfig) async throws -> [Business] {
		let location = config.location
		isLoading = true
		defer { isLoading = false }

		let lat = location.latitude
		let lon = location.longitude
		let request = baseRequest
			.addQuery(.coordinate(lat, lon))
			.build()

		let result: Root = try await restClient.execute(request)
		let totalCount = result.total
		hasMoreToLoad = totalCount >= ((currentPage + 1) * limit)
		return result.businesses
	}
}
