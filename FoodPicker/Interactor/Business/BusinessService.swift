//
//  BusinessService.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/12.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

class BusinessService {
  static let sharedInstance: BusinessService = .init()

  static func fetchBusinesses(lat: Double, lon: Double, option: RestaurantSorting? = nil, limit: Int) async throws -> Array<Business> {
    if !NetworkMonitor.shared.isConnected { throw URLRequestError.noInternet }
    let service = BusinessProvider.search(lat, lon, sortBy: option?.sortBy ?? "distance", limit: limit)
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let response = await NetworkService.createHttpRequest(service: service).serializingDecodable(Root.self, decoder: decoder).response
    switch (response.result) {
    case .success(let root):
      return root.businesses
    case .failure(let error):
      throw URLRequestError.noResponse(message: "\(error.localizedDescription)")
    }
  }

  static func createDataTask(lat: Double, lon: Double, option: RestaurantSorting, limit: Int = 20) -> Task<Array<Business>, Error> {
    return Task.init {
      let result = try await BusinessService.fetchBusinesses(lat: lat, lon: lon, option: option, limit: limit)
      if result.isEmpty {
        throw URLRequestError.noResponse(message: "result of fetchBusiness is empty.")
      }
      return result
    }
  }

  static func fetchDetail(id: String) async throws -> Detail {
    if !NetworkMonitor.shared.isConnected { throw URLRequestError.noInternet }
    let service = BusinessProvider.detail(id: id)
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let response = await NetworkService.createHttpRequest(service: service).serializingDecodable(Detail.self, decoder: decoder).response
    switch (response.result) {
    case .success(let detail):
      return detail
    case .failure(let error):
      throw URLRequestError.noResponse(message: "\(error.localizedDescription)")
    }
  }
}