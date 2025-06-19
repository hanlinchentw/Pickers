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
    switch (lhs, rhs) {
    case (.invalidUrl, .invalidUrl):
      true
    case let (.custom(lhsType), .custom(rhsType)):
      lhsType.localizedDescription == rhsType.localizedDescription
    case let (.invalidStatusCode(lhsType), .invalidStatusCode(rhsType)):
      lhsType == rhsType
    case (.invalidData, .invalidData), (.invalidResponse, .invalidResponse), (.failedToDecode, .failedToDecode):
      true
    default:
      false
    }
  }
}

extension NetworkingError {
  var errorDescription: String? {
    switch self {
    case .invalidUrl:
      "URL isn't valid"
    case .invalidStatusCode:
      "Status code falls into the wrong range"
    case .invalidData, .invalidResponse:
      "Response data is invalid"
    case .failedToDecode:
      "Failed to decode"
    case let .custom(err):
      "Something went wrong \(err.localizedDescription)"
    }
  }
}
