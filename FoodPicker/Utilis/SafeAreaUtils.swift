//
//  SafeArea.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/17.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import UIKit

final class SafeAreaUtils {
  static var safeAreaInset: UIEdgeInsets? {
    return UIApplication.shared.keyWindow?.safeAreaInsets
  }
  static var top: CGFloat {
    guard let safeAreaInset = safeAreaInset else {
      return 0
    }
    return safeAreaInset.top
  }

  static var bottom: CGFloat {
    guard let safeAreaInset = safeAreaInset else {
      return 0
    }
    return safeAreaInset.bottom
  }
}
