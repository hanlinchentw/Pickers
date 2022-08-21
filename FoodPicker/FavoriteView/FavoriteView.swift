//
//  FavoriteView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/20.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct FavoriteView: View {
  @Environment(\.managedObjectContext) private var viewContext

  @FetchRequest(sortDescriptors: []) var selectedRestaurants: FetchedResults<SelectedRestaurant>
  @FetchRequest(sortDescriptors: []) var likedRestaurants: FetchedResults<LikedRestaurant>

  var body: some View {
    NavigationView {
      ZStack {
        Color.listViewBackground
          .ignoresSafeArea()
        ScrollView(.vertical, showsIndicators: false) {
          VStack(spacing: 16) {
            ForEach(0 ..< likedRestaurants.count, id: \.self) { index in
              let restaurant = likedRestaurants[index].restaurant
              let isSelected = selectedRestaurants.contains(where: { $0.id == restaurant.id })
              let presenter = RestaurantPresenter(restaurant: restaurant, isSelected: isSelected)
              RestaurantListItemView(presenter: presenter) {}
            }
          }
          .safeAreaInset(edge: .top, content: {
            Spacer().frame(height: 100)
          })
        }

        VStack {
          Rectangle()
            .fill(Color.white)
            .overlay(Text("Favorite").en16ArialBold().padding(.top, 30))
            .frame(width: UIScreen.screenWidth, height: 99)
            .cornerRadius(32)
          Spacer()
        }
        .ignoresSafeArea()
      }
      .navigationBarHidden(true)
    }

  }
}

struct FavoriteView_Previews: PreviewProvider {
  static var previews: some View {
    FavoriteView()
  }
}
