//
//  HeightPreferenceKey.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/15.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import SwiftUI

struct HeightPreferenceKey: PreferenceKey {
  typealias Value = CGFloat
  static var defaultValue: CGFloat = 40
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}
