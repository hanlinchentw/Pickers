//
//  Text+Extensions.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/13.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

extension Text {
  func en14Arial() -> Text {
    return self.font(Font.custom("ArialMT", fixedSize: 14))
  }

  func en14ArialBold() -> Text {
    return self.font(Font.custom("Arial-BoldMT", fixedSize: 14))
  }

  func en16ArialBold() -> Text {
    return self.font(Font.custom("Arial-BoldMT", fixedSize: 16))
  }

  func en24ArialBold() -> Text {
    return self.font(Font.custom("Arial-BoldMT", fixedSize: 24))
  }
}
