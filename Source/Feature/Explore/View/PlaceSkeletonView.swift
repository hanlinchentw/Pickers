//
//  PlaceSkeletonView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/4/2.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import SwiftUI

struct PlaceSkeletonView: View {
  var body: some View {
    HStack {
      Color.gray8
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .frame(width: 80, height: 80)
      VStack(alignment: .leading, spacing: 2) {
        Color.gray8
          .clipShape(RoundedRectangle(cornerRadius: 16))
          .frame(width: 250)
        Spacer()
        Color.gray8
          .clipShape(RoundedRectangle(cornerRadius: 16))
          .frame(width: 200)
        Spacer()
        Color.gray8
          .clipShape(RoundedRectangle(cornerRadius: 16))
          .frame(width: 100)
      }
      .padding(.leading, 8)
      Spacer()
    }
    .shimmer()
    .frame(height: 80)
  }
}

#Preview {
  VStack {
    PlaceSkeletonView()
    PlaceSkeletonView()
    PlaceSkeletonView()
    PlaceSkeletonView()
    PlaceSkeletonView()
  }
}
