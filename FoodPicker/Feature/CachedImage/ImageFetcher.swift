//
//  ImageFetcher.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/23.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

struct ImageFetcher {
  func fetch(_ imageUrl: String) async throws -> Data {
    guard let url = URL(string: imageUrl) else {
      throw FetcherError.invalidUrl
    }

    let (data, _) = try await URLSession.shared.data(from: url)
    return data
  }
}

private extension ImageFetcher {
  enum FetcherError: Error {
    case invalidUrl
  }
}
