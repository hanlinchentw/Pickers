//
//  HttpClient.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/1/6.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import APIKit
import Foundation

enum HttpClientError: Error {
  case failToBuildRequest(any Request)
}

final class HttpClient {
  func execute(_ request: any Request) async throws -> (Data, URLResponse) {
    let urlRequest = try request.buildURLRequest()
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    return (data, response)
  }
}
