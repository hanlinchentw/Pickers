//
//  FirstRowPressenter.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/20.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit

class FirstRowPressenter: DetailRowPresenter {
  var delegate: DetailCellDelegate?
  var detail : Detail
  let config: DetailConfig

  init(_ config: DetailConfig, detail: Detail) {
    self.detail = detail
    self.config = config
  }

  var icon: String? {
    return nil
  }

  var iconIsHidden: Bool {
    return true
  }

  var title: String {
    return detail.name
  }

  var content: NSAttributedString? {
    var categories = ""
    detail.categories.forEach { category in
      categories.append("・")
      categories.append(contentsOf: category.title)
    }
    let price = detail.price ?? "-"
    let attributedString = NSMutableAttributedString(string: "\(price)\(categories)",
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    return attributedString
  }

  var rightText: String? {
    return "★\(detail.rating)(\(detail.reviewCount)+)"
  }

  var actionButtonImageName: String? {
    return nil
  }

  var actionButtonIsHidden: Bool {
    return true
  }
}
