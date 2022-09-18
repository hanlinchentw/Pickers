//
//  PopularSectionView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/13.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct PopularSectionView: View {
  // MARK: - Environment
  @EnvironmentObject var viewModel: RestaurantViewModel
  @EnvironmentObject var coordinator: MainCoordinator
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(sortDescriptors: []) var selectedRestaurants: FetchedResults<SelectedRestaurant>
  @FetchRequest(sortDescriptors: []) var likedRestaurants: FetchedResults<LikedRestaurant>

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      if (viewModel.showContent()) {
        Text("Popular")
          .en24Bold()
          .padding(.leading, 16)
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 16) {
            ForEach(0 ..< viewModel.dataCount(), id: \.self) { index in
              if viewModel.dataSource.loadingState != LoadingState.loaded {
                DummyRestaurantCardView().padding(.vertical, 8)
              } else {
                let restaurant = viewModel.dataSource.viewObjects[index]

                let isLiked = likedRestaurants.contains(where: {$0.id == restaurant.id})
                let isSelected = selectedRestaurants.contains(where: {$0.id == restaurant.id})

                let actionButtonMode: ActionButtonMode = isSelected ? .select : .deselect
                let presenter = RestaurantPresenter(restaurant: restaurant, actionButtonMode: actionButtonMode, isLiked: isLiked)

                RestaurantCardView(presenter: presenter) {
                  viewModel.selectRestaurant(isSelected: isSelected, restaurant: restaurant)
                } _: {
                  viewModel.likeRestaurant(isLiked: isSelected, restaurant: restaurant)
                }
                .onTapGesture {
                  coordinator.pushToDetailView(id: restaurant.id)
                }
                .padding(.vertical, 8)
              }
            }
          }
          .padding(.leading, 16)
        }
      }
    }
  }
}
