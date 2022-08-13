//
//  BusinessService.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/12.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import RxSwift

class BusinessService {
  static let sharedInstance: BusinessService = .init()

  func fetchBusinesses(lat: Double, lon: Double, option: RestaurantSorting? = nil) async throws -> Array<Business> {
    let service = BusinessProvider.search(lat, lon, sortBy: option?.search ?? "distance", limit: 50)
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

  func getBusinesses(lat: Double, lon: Double, option: RestaurantSorting? = nil) -> Single<Array<Business>> {
    return NetworkService
      .requestWithSingleResponse(service: BusinessProvider.search(lat, lon, sortBy: option?.search ?? "distance", limit: 50))
      .map({ data throws in
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let rawData = try! decoder.decode(Root.self, from: data!)
        return rawData.businesses
      })
  }

  func fetchDetail(id: String) -> Single<Details> {
    return NetworkService.requestWithSingleResponse(service: BusinessProvider.detail(id: id))
      .map { data throws in
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let detail = try! decoder.decode(Details.self, from: data!)
        return detail
      }
  }
}
