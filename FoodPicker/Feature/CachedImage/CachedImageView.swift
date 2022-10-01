//
//  CachedImageView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/27.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit
import Combine

class CachedImageView: UIImageView {
  private var viewModel = CachedAsyncImageViewModel()

  @Published var url: String?

  private var set = Set<AnyCancellable>()
  init() {
    super.init(frame: .zero)
    bindImageUrl()
    bindLoadingState()
    clipsToBounds = true
    layer.cornerRadius = 16
    backgroundColor = .lightlightGray
    contentMode = .scaleAspectFill
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  // MARK: -  Binding
  func bindImageUrl() {
    $url.sink { [weak self] nullableUrl in
      guard let url = nullableUrl else {
        return
      }
      Task {
				await self?.viewModel.load(url, cache: ImageCacheImpl.shared)
      }
    }
    .store(in: &set)
  }

  func bindLoadingState() {
    viewModel.$currentState.sink { state in
      switch (state) {
      case .loading:
        self.image = nil
      case .success(let data):
        let image = UIImage(data: data)
        self.image = image
      case .failed(_):
        self.image = UIImage(named: "defaultRestaurant")
      case .none:
        break
      }
    }
    .store(in: &set)
  }
}
