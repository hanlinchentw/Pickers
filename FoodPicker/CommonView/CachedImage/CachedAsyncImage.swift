//
//  CachedAsyncImage.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/23.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct CachedAsyncImage<Content: View>: View {
  @StateObject var viewModel = CachedAsyncImageViewModel()
  let url: String


  @ViewBuilder var content: (AsyncImagePhase) -> Content
  var body: some View {
    ZStack {
      switch viewModel.currentState {
      case .loading:
        content(.empty)
      case .success(let data):
        if let image = UIImage(data: data) {
          content(.success(Image(uiImage: image)))
        } else {
          content(.failure(CachedImageError.invalidData))
        }
      case .failed(let error):
        content(.failure(error))
      default:
        content(.empty)
      }

    }
    .task {
      await viewModel.load(url)
    }
  }
}

struct CachedAsyncImage_Previews: PreviewProvider {
  static var previews: some View {
    CachedAsyncImage(url: Constants.defaultImageURL) { phase in

    }
  }
}

extension CachedAsyncImage {
  enum CachedImageError: Error {
    case invalidData
  }
}
