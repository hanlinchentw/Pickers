//
//  NetworkService.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/14.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import Alamofire
import Combine

enum URLRequestError: Error {
	case noInternet
	case serverFailure
	case clientFailure
	case noResponse(message: String)
	case emptyResponse
}

protocol NetworkProvider {
	var baseURL: String { get }
	var headers: HTTPHeaders? { get }
	var method: HTTPMethod { get }
	var path: String { get }
	var parameters: [String: Any] { get }
}

class NetworkService {
	typealias DataResponseHandler = ((AFDataResponse<Data?>) -> Void)

	static func createHttpRequest(service: NetworkProvider) -> DataRequest {
		let urlPath = URL(string: "\(service.baseURL)\(service.path)")!
		let request = AF.request(urlPath, method: service.method, parameters: service.parameters, headers: service.headers)
		return request
	}
	
	static func createRequest(provider: NetworkProvider) -> DataRequest {
		var urlString = "\(provider.baseURL)\(provider.path)?"
		for (key, value) in provider.parameters {
			urlString.append("\(key)=\(value)")
			urlString.append("&")
		}
		urlString.append("key=\(Constants.GOOGLE_PLACE_API_KEY)")
		print("urlstring >>> \(urlString)")
		let urlPath = URL(string: urlString)!
		
		let request = AF.request(urlPath, method: provider.method)
		return request
		
	}
}
