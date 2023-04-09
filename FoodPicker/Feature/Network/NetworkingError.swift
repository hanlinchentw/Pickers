//
//  NetworkingError.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/1.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation

enum NetworkingError: LocalizedError {
	case invalidUrl
	case custom(error: Error)
	case invalidStatusCode(statusCode: Int)
	case invalidResponse
	case invalidData
	case failedToDecode
}

extension NetworkingError: Equatable {
	static func == (lhs: NetworkingError, rhs: NetworkingError) -> Bool {
		switch(lhs, rhs) {
		case (.invalidUrl, .invalidUrl):
			return true
		case (.custom(let lhsType), .custom(let rhsType)):
			return lhsType.localizedDescription == rhsType.localizedDescription
		case (.invalidStatusCode(let lhsType), .invalidStatusCode(let rhsType)):
			return lhsType == rhsType
		case (.invalidData, .invalidData), (.invalidResponse, .invalidResponse),(.failedToDecode, .failedToDecode):
			return true
		default:
			return false
		}
	}
}

extension NetworkingError {
	var errorDescription: String? {
		switch self {
		case .invalidUrl:
			return "URL isn't valid"
		case .invalidStatusCode:
			return "Status code falls into the wrong range"
		case .invalidData, .invalidResponse:
			return "Response data is invalid"
		case .failedToDecode:
			return "Failed to decode"
		case .custom(let err):
			return "Something went wrong \(err.localizedDescription)"
		}
	}
}
