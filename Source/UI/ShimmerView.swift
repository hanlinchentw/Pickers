//
//  ShimmerView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/20.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct Shimmer<Content: View>: View {
  @State private var startPoint = UnitPoint(x: -1, y: 0.5)
  @State private var endPoint: UnitPoint = .leading

  @ViewBuilder let content: () -> Content
  var body: some View {
    ZStack {
      content()
      LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.7), Color.black.opacity(0.3), Color.gray.opacity(0.7)]), startPoint: startPoint, endPoint: endPoint)
        .blendMode(.screen)
        .onAppear {
          withAnimation(Animation.linear(duration: 1.5)
            .repeatForever(autoreverses: false)) {
              startPoint = .trailing
              endPoint = UnitPoint(x: 2, y: 0.5)
            }
        }
    }
  }
}

struct ShimmerModifier: ViewModifier {
  func body(content: Content) -> some View {
    Shimmer {
      content
    }
  }
}
