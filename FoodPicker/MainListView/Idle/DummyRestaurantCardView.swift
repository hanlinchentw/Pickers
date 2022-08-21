//
//  RestaurantCardView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/12.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct DummyRestaurantCardView: View {



  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      VStack(alignment: .leading) {
        Color.gray.opacity(0.5)
          .frame(width: 264, height: 128)
          .cornerRadius(16)
          .padding(.top, 8)
          .padding(.horizontal, 8)
        VStack(alignment: .leading, spacing: 12) {
          RoundedRectangle(cornerRadius: 4)
            .fill(Color.gray.opacity(0.5))
            .frame(width: 120, height: 12)
          RoundedRectangle(cornerRadius: 4)
            .fill(Color.gray.opacity(0.5))
            .frame(width: 90, height: 12)
          RoundedRectangle(cornerRadius: 4)
            .fill(Color.gray.opacity(0.5))
            .frame(width: 60, height: 12)
        }
        .padding(.leading, 8)
        .padding(.top, 8)
        Spacer()
      }
    }
    .frame(width: 280, height: 250)
    .roundedViewWithShadow(cornerRadius: 16,
                           backgroundColor: Color.white,
                           shadowColor: Color.gray.opacity(0.1),
                           shadowRadius: 4)
  }
}

struct DummyRestaurantCardView_preview: PreviewProvider {
  static var previews: some View {
    DummyRestaurantCardView()
  }
}
