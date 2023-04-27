//
//  FourthRowPresenter.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/20.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit

class FourthRowPresenter: DetailRowPresenter {
  var delegate: DetailCellDelegate?
  let detail: Detail
  let config: DetailConfig

  init(_ config: DetailConfig, detail: Detail) {
    self.detail = detail
    self.config = config
  }

  var icon: String? {
    "icnCallXs"
  }

  var iconIsHidden: Bool {
    return false
  }

  var title: String {
    return "Number"
  }

  var content: NSAttributedString? {
    return NSAttributedString(string: detail.displayPhone ?? "No providing")
  }

  var rightText: String? {
    return nil
  }

  var actionButtonIsHidden: Bool {
    return true
  }

  var actionButtonImageName: String? {
    return "btnCall"
  }
}
