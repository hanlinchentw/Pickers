//
//  TextField+Extensions.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/21.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import SwiftUI

extension TextField {
  func placeholder(
    when shouldShow: Bool,
    alignment: Alignment = .leading,
    @ViewBuilder placeholder: () -> some View
  ) -> some View {
    ZStack(alignment: alignment) {
      placeholder().if(!shouldShow, transform: { $0.hidden() })
      self
    }
  }
}
