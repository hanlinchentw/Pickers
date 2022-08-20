//
//  ThirdPresenter.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/20.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit
import MapKit

class ThirdRowPresenter: DetailRowPresenter {
  var delegate: DetailCellDelegate?
  let detail: Detail
  let config: DetailConfig
  
  init(_ config: DetailConfig, detail: Detail) {
    self.detail = detail
    self.config = config
  }

  var icon: String? {
    "icnLocationXs"
  }

  var iconIsHidden: Bool {
    false
  }

  var title: String {
    "Address"
  }

  var content: NSAttributedString? {
    addressSub
  }

  var rightText: String? {
    nil
  }

  var actionButtonIsHidden: Bool {
    false
  }

  var actionButtonImageName: String? {
    "btnGoogleMaps"
  }

  var addressSub : NSAttributedString {
    guard let address : String = detail.location?.displayAddress.reduce("",{$0 + " " + $1})
    else { return NSAttributedString(string: "No Providing") }
    let attributedString = NSMutableAttributedString(string: address,
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.customblack])
    return attributedString
  }

  func actionButtonTapped() {
    delegate?.didTapActionButton(config)
  }
}
