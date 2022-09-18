//
//  IdleRestaurantListItemView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/20.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct IdleRestaurantListItemView: View {
    var body: some View {
      HStack {
        Color.gray.opacity(0.5)
        .frame(width: 93, height: 93)
        .cornerRadius(16)
        .padding(.top, 8)
        .padding(.horizontal, 8)
        VStack(alignment: .leading, spacing: 12) {
          RoundedRectangle(cornerRadius: 4)
            .fill(Color.gray.opacity(0.5))
            .frame(width: 200, height: 12)
          RoundedRectangle(cornerRadius: 4)
            .fill(Color.gray.opacity(0.5))
            .frame(width: 150, height: 12)
          RoundedRectangle(cornerRadius: 4)
            .fill(Color.gray.opacity(0.5))
            .frame(width: 80, height: 12)
        }
        .padding(.top, 8)
        Spacer()
      }
    }
}

struct IdleRestaurantListItemView_Previews: PreviewProvider {
    static var previews: some View {
        IdleRestaurantListItemView()
    }
}
