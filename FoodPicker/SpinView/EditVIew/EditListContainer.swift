//
//  EditListContainer.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/15.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct EditListContainer: View {
  @Environment(\.managedObjectContext) var viewContext
  @Binding var restaurants: Array<RestaurantViewObject>
  @State private var contentHeight: CGFloat = 40
  
  var numOfRestaurantsDisplayText: String {
    return "\(restaurants.count) restaurants"
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

      if restaurants.isEmpty {
        Text("I don't want to be empty 😢")
          .en18Bold()
          .foregroundColor(Color.gray)
          .padding(.top, 16)
      }

      ScrollView(.vertical, showsIndicators: false) {
        VStack {
          ForEach(restaurants, id: \.self) { viewObject in
            let presenter = RestaurantPresenter(restaurant: viewObject, actionButtonMode: .edit)
            RestaurantListItemView(presenter: presenter) {
              restaurants.removeAll(where: { $0.id == viewObject.id })
            }
            .padding(.trailing, 16)
          }
        }
        .overlay(
          GeometryReader { geo in
            Color.clear
              .preference(key: HeightPreferenceKey.self, value: geo.size.height)
          })
      }
      .safeAreaInset(edge: .bottom, content: { Spacer().height(50) })
      .frame(maxHeight: contentHeight, alignment: .center)
      
    }
    .onPreferenceChange(HeightPreferenceKey.self, perform: {
      contentHeight = $0
    })
  }
}

struct EditListContainer_Previews: PreviewProvider {
  static var previews: some View {
    EditListContainer(restaurants: .constant(MockedRestaurant.TEST_RESTAURANT_VIEW_OBJECT_ARRAY))
  }
}
