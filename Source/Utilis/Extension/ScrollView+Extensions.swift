//
//  ScrollView+Extensions.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/1/12.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
  @ViewBuilder
  func scrollOffsetTracking(in namespace: String, onChange: @escaping (CGPoint) -> Void) -> some View {
    background(GeometryReader { geometry in
      Color.clear
        .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named(namespace)).origin)
    })
    .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: onChange)
  }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGPoint = .zero
  static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
  }
}
