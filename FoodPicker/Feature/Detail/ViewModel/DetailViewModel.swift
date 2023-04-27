//
//  DetailViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/20.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ImageSlideshow

class DetailViewModel {
  let id: String
  @Published var detail: Detail? = nil
  @Published var isLiked: Bool = false
  @Published var isSelected: Bool = false
  @Published var isExpanded = false

  init(restaurantId: String) {
    self.id = restaurantId
  }
}

extension DetailViewModel {
  @MainActor
  func refresh() {
  }

  func selectButtonTapped() {
  }

  func likeButtonTapped() {
  }

  func shareButtonTapped() {
    let activityViewController = UIActivityViewController(activityItems: [detail?.name, detail?.url], applicationActivities: nil)
    OperationQueue.main.addOperation {
      PresentHelper.topViewController?.present(activityViewController, animated: true, completion: nil)
    }
  }
}

extension DetailViewModel {
  @MainActor
  func fetchDetail() {
    MBProgressHUDHelper.showLoadingAnimation()
    Task {
      do {
        let detail = try await BusinessService.fetchDetail(id: self.id)
        self.detail = detail
        MBProgressHUDHelper.hideLoadingAnimation()
      } catch {
        print("fetchDetail.failed >>> \(error.localizedDescription)")
        MBProgressHUDHelper.hideLoadingAnimation()
      }
    }
  }
}

extension DetailViewModel {
	var imageUrl: [URL] {
		if let photos = detail?.photos, !photos.isEmpty {
			return photos
		}
		
		if let imageUrl = detail?.imageUrl {
			return [URL(string: imageUrl) ?? URL(string: Constants.defaultImageURL)!]
		}
		
		return []
	}
	
	var imageSource: Array<AlamofireSource> {
		let source = imageUrl.map { AlamofireSource(url: $0) }
		return source
	}
}
