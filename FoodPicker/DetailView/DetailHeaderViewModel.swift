//
//  DetailHeaderViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/11/11.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import Foundation
struct DetailHeaderViewModel{
  var detail : Detail?

  init(detail: Detail?) {
    self.detail = detail
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
    return "btnBookmarkHeartPressed"
//    return restaurant.isLiked ? "btnBookmarkHeartPressed" : "btnBookmarkHeartDefault"
  }
}
