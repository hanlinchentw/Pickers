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
  func placeholder<Content: View>(
    when shouldShow: Bool,
    alignment: Alignment = .leading,
    @ViewBuilder placeholder: () -> Content) -> some View {

      ZStack(alignment: alignment) {
        placeholder().opacity(shouldShow ? 1 : 0)
        self
      }
    }
}
