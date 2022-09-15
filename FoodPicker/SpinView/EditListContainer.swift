//
//  EditListContainer.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/15.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct EditListContainer: View {
  @Binding var list: List
  @State private var contentHeight: CGFloat = 40

  var numOfRestaurantsDisplayText: String {
    return "\(list.restaurants.count) restaurants"
  }

  var body: some View {
    VStack {
      HStack {
        Text(numOfRestaurantsDisplayText)
          .en14()
          .foregroundColor(.black.opacity(0.8))
          .padding(.leading, 16)
        Spacer()
      }
      .padding(.top, 12)
      //      GeometryReader { proxy in
      ScrollView(.vertical, showsIndicators: false) {
        GeometryReader { geo in
          VStack {
            ForEach(0 ..< list.restaurants.count, id: \.self) { index in
              let restaurant = Array(list.restaurants)[index] as? Restaurant
              let viewObject = RestaurantViewObject(restaurant: restaurant!)
              let presenter = RestaurantPresenter(restaurant: viewObject, actionButtonMode: .none)
              RestaurantListItemView(presenter: presenter) {}
            }
          }
          .overlay(
            GeometryReader { geo in
              Color.clear
                .preference(key: HeightPreferenceKey.self, value: geo.size.height)
            })
        }
      }
      .frame(maxHeight: contentHeight, alignment: .center)
    }
    .onPreferenceChange(HeightPreferenceKey.self, perform: {
      contentHeight = $0
    })
  }
}

struct EditListContainer_Previews: PreviewProvider {
  static var previews: some View {
    EditListContainer(list: .constant(MockedList.mock_list_1))
  }
}
