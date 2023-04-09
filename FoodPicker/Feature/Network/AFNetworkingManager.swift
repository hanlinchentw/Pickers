//
//  NetworkingManager.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/1.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation
import Alamofire

@globalActor actor AFNetworkingManager {
	static let shared = AFNetworkingManager()
	
	private let maxWaitTime: Double = 60
	
	func request(_ config: URLSessionConfiguration = URLSessionConfiguration.af.default, url: String, parameters: Parameters?) async throws -> Data {
		let sessionManager = Session(configuration: config)
		guard let url = URL(string: url) else {
			throw NetworkingError.invalidUrl
		}
		
		return try await withCheckedThrowingContinuation { continuation in
			sessionManager.request(
				url,
				parameters: parameters,
				headers: [:],
				requestModifier: { $0.timeoutInterval = self.maxWaitTime }
			)
			.responseData { afDataResponse in
				guard let response = afDataResponse.response else {
					continuation.resume(throwing: NetworkingError.invalidResponse)
					return
				}
				
				guard (200...300) ~= response.statusCode else {
					continuation.resume(throwing: NetworkingError.invalidStatusCode(statusCode: response.statusCode))
					return
				}
				
				switch(afDataResponse.result) {
				case let .success(data):
					continuation.resume(returning: data)
				case let .failure(error):
					continuation.resume(throwing: self.handleError(error: error))
				}
			}
		}
	}
	
	func request(_ config: URLSessionConfiguration = URLSessionConfiguration.af.default, url: String, parameters: Parameters?, completion: @escaping((Result<Data, Error>) -> Void)) throws {
		let sessionManager = Session(configuration: config)
		sessionManager.request(
			url,
			parameters: parameters,
			headers: [:],
			requestModifier: { $0.timeoutInterval = self.maxWaitTime }
		)
		.responseData { afDataResponse in
			guard let response = afDataResponse.response else {
				completion(.failure(NetworkingError.invalidResponse))
				return
			}
			
			guard (200...300) ~= response.statusCode else {
				completion(.failure(NetworkingError.invalidStatusCode(statusCode: response.statusCode)))
				return
			}
			
			switch(afDataResponse.result) {
			case let .success(data):
				completion(.success(data))
			case let .failure(error):
				completion(.failure(self.handleError(error: error)))
			}
		}
	}
	
	private func handleError(error: AFError) -> Error {
		if let underlyingError = error.underlyingError {
			let nserror = underlyingError as NSError
			let code = nserror.code
			if code == NSURLErrorNotConnectedToInternet ||
					code == NSURLErrorTimedOut ||
					code == NSURLErrorInternationalRoamingOff ||
					code == NSURLErrorDataNotAllowed ||
					code == NSURLErrorCannotFindHost ||
					code == NSURLErrorCannotConnectToHost ||
					code == NSURLErrorNetworkConnectionLost
			{
				var userInfo = nserror.userInfo
				userInfo[NSLocalizedDescriptionKey] = "Unable to connect to the server"
				let currentError = NSError(
					domain: nserror.domain,
					code: code,
					userInfo: userInfo
				)
				return currentError
			}
		}
		return error
	}
}
