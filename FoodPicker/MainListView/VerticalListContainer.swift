//
//  VerticalRestaurantListContainer.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/13.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct VerticalListContainer: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text(RestaurantSorting.all.description)
        .en24ArialBold()
        .padding(.leading, 16)
      VStack(spacing: 16) {
        ForEach(0 ..< 20) { _ in
          RestaurantListItemView()
        }
      }
      .padding(.top, 16)
      .background(Color.white)
      .cornerRadius(24, corners: [.topLeft, .topRight])
      .redacted(reason: .placeholder)
      Spacer()
    }
  }
}

struct VerticalRestaurantListContainer_Previews: PreviewProvider {
  static var previews: some View {
    VerticalListContainer()
  }
}

struct RestaurantListItemView: View {
  var body: some View {
    HStack {
      AsyncImage(url: nil) { _ in
        Color.gray.opacity(0.7)
      }
      .frame(width: 93, height: 93)
      .cornerRadius(16)
      .padding(.leading, 16)
      VStack(alignment: .leading) {
        VStack(alignment: .leading, spacing: 6) {
          Text("Papa's Coffee").en16ArialBold()
          Text("$100-300・Coffee・300m away").en14Arial()
        }
        HStack(spacing: 4, content: {
          Image("ratingStarXs")
          Text("4.8").en14Arial()
          Text("(300+)").en14Arial()
          Spacer()
        })
      }
      .padding(.leading, 6)
      Image("addL")
        .shadow(color: Color.gray.opacity(0.25), radius: 3, x: 0, y: 0)
    }
  }
}
