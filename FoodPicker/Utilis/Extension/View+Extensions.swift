//
//  View+Extensions.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/12.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
  @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }

  func height(_ height: CGFloat) -> some View {
    return self.frame(height: height)
  }

  func roundedViewWithShadow(cornerRadius: CGFloat, backgroundColor: Color, shadowColor: Color, shadowRadius: CGFloat) -> some View {
    return self.background(
      RoundedRectangle(cornerRadius: cornerRadius)
      .fill(backgroundColor)
      .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: 0)
    )
  }

  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
      clipShape(RoundedCorner(radius: radius, corners: corners))
  }

  func `shimmer`() -> some View {
    modifier(ShimmerModifier())
  }
}
