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
	
	static func fetchBusinesses(query: Query) async throws -> Array<Business> {
		if !NetworkMonitor.shared.isConnected { throw URLRequestError.noInternet }
		let service = BusinessProvider.search(query.lat, query.lon, sortBy: query.option.sortBy, offset: query.offset, limit: query.limit)
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
extension BusinessService {
	struct Query {
		var lat: Double
		var lon: Double
		var option: SearchOption
		var limit: Int
		var offset: Int
	}
}


struct BusinessGenerator: AsyncSequence, AsyncIteratorProtocol {
	typealias Element = Array<Business>
	
	let query: BusinessService.Query
	private var comparison: [Business]?
	
	mutating func next() async throws -> Element? {
		if comparison == nil {
			// If this is our first iteration, return the initial value
			comparison = try await fetchData()
		} else {
			// Otherwise, sleep for a while and see if our data changed
			while true {
				let latestData = try await fetchData()
				
				if latestData != comparison {
					// New data is different from previous data,
					// so update previous data and send it back
					comparison = latestData
					break
				}
			}
		}
		
		if comparison == nil {
			return nil
		} else {
			return comparison
		}
	}
	
	private func fetchData() async throws -> Element {
		let result = try await BusinessService.fetchBusinesses(query: query)
		return result
	}
	
	func makeAsyncIterator() -> BusinessGenerator {
		self
	}
}
