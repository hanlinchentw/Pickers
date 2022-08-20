//
//  DetailHeaderViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/11/11.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import Foundation
import Combine

class DetailHeaderViewModel: ObservableObject {
  var detail : Detail?
  @Published var isLiked: Bool

  init(isLiked: Bool, detail: Detail?) {
    self.detail = detail
    self.isLiked = isLiked
  }
  //MARK: - Header
  var imageUrl : [URL]? {
    if let photos = detail?.photos, !photos.isEmpty {
      return photos
    }

    if let imageUrl = detail?.imageUrl {
      return [imageUrl]
    }

    return []
  }
  var likeButtonImageName: String {
    return isLiked ? "btnBookmarkHeartPressed" : "btnBookmarkHeartDefault"
  }
}
