//
//  PocketFolderView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/1/8.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import SwiftUI

struct PocketFolderView: View {
  var color: [Color] = [
    .red,
    .blue,
    .butterScotch,
    .freshGreen,
    .brown,
    .listViewBackground,
    .accentColor,
    .gray,
    .indigo
  ]

  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()
      VStack {
        Text("Pocket")
          .en24Bold()
          .foregroundStyle(.white)
        ScrollView {
          VStack(spacing: 120) {
            ForEach(0..<20) { index in
              GeometryReader { proxy in
                let maxY = proxy.bounds(of: .scrollView)?.maxY
                let minY = proxy.bounds(of: .scrollView)?.minY
                color[index % 9]
                  .frame(width: widthScale(yPosition: maxY) * 200, height: 300)
                  .cornerRadius(24)
                  .scrollTransition { content, _ in
                    content
                      .opacity(opacityScale(yPosition: minY))
                  }
                  .frame(width: proxy.size.width, alignment: .center)
                  .shadow(radius: 5)
              }
            }
          }
        }
        .contentMargins(.top, UIScreen.height / 6)
        .contentMargins(.bottom, 300)
        .scrollClipDisabled()
        .scrollIndicators(.hidden)
      }
    }
  }

  func widthScale(yPosition: CGFloat?) -> Double {
    guard let yPosition else { return 0 }
    return max(1, 1 - Double((yPosition - UIScreen.height / 1.2) / UIScreen.height / 1.2))
  }

  func opacityScale(yPosition: CGFloat?) -> Double {
    guard let yPosition else { return 0 }
    let base = 1 - yPosition / UIScreen.screenWidth
    return Double(pow(base, 8))
  }
}

#Preview {
  PocketFolderView()
}
