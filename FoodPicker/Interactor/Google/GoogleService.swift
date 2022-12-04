//
//  File.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/30.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

class GoogleService {
	static func fetchNearyby(query: Query) async throws -> Array<Nearyby> {
		if !NetworkMonitor.shared.isConnected { throw URLRequestError.noInternet }
		let provider = GoogleProvider.nearby(query.lat, query.lon, rankBy: query.option?.sortBy ?? "distance")
		let decoder = JSONDecoder()
//		decoder.keyDecodingStrategy = .convertFromSnakeCase

		let response = await NetworkService.createRequest(provider: provider).serializingDecodable(Base.self, decoder: decoder).response
		print("fetchNearyby >>> response: \(response)")
		switch (response.result) {
		case .success(let base):
			return base.results
		case .failure(let error):
			throw URLRequestError.noResponse(message: "\(error.localizedDescription)")
		}
	}
}
