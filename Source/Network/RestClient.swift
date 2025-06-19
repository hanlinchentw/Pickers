//
//  RestClient.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/1/6.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import APIKit
import Foundation

final class RestClient {
  private lazy var jsonDecoder: JSONDecoder = {
    var decoder = JSONDecoder()
    return decoder
  }()

  let httpClient: HttpClient

  init(httpClient: HttpClient) {
    self.httpClient = httpClient
  }

  func execute<T: Decodable>(_ request: any Request) async throws -> T {
    let (data, _) = try await httpClient.execute(request)
    return try jsonDecoder.decode(T.self, from: data)
  }
}
