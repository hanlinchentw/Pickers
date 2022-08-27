//
//  CachedAsyncImageViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/23.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

class CachedAsyncImageViewModel: ObservableObject {
  @Published private(set) var currentState: CurrentState?

  private let fetcher = ImageFetcher()

  @MainActor func load(_ imageUrl: String, cache: ImageCache = .shared) async {

    self.currentState = .loading

    do {
      if let cachedData = cache.object(forKey: NSString.init(string: imageUrl)) {
        self.currentState = .success(cachedData)
        return
      }

      let remoteData = try await fetcher.fetch(imageUrl)

      self.currentState = .success(remoteData)

      cache.set(object: remoteData as NSData, forKey: NSString.init(string: imageUrl))
    } catch {
      self.currentState = .failed(error)
    }
  }
}

extension CachedAsyncImageViewModel {
  enum CurrentState {
    case loading
    case failed(_ error: Error)
    case success(_ data: Data)
  }
}
