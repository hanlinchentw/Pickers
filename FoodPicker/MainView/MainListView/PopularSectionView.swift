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
  @EnvironmentObject var coordinator: MainCoordinator
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(sortDescriptors: []) var selectedRestaurants: FetchedResults<SelectedRestaurant>
  @FetchRequest(sortDescriptors: []) var likedRestaurants: FetchedResults<LikedRestaurant>
  // MARK: - Property
  @Binding var data: MainListViewModel.ListSectionData
  var showContent: (_ data: MainListViewModel.ListSectionData) -> Bool
  var dataCount: (_ data: MainListViewModel.ListSectionData) -> Int
  // MARK: - Use case
  var selectUsecase = SelectRestaurantUsecase()
  var likeUsecase = LikeRestaurantUsecase()

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      if (showContent(data)) {
        Text("Popular")
          .en24Bold()
          .padding(.leading, 16)
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 16) {
            ForEach(0 ..< dataCount(data), id: \.self) { index in
              if data.loadingState != LoadingState.loaded {
                DummyRestaurantCardView().padding(.vertical, 8)
              } else {
                let restaurant = data.viewObjects[index]

                let isLiked = likeUsecase.checkIsRestaurantLiked(restaurant.id)
                let isSelected = selectUsecase.checkIsRestaurantSelected(restaurant.id)

                let actionButtonMode: ActionButtonMode = isSelected ? .select : .deselect
                let presenter = RestaurantPresenter(restaurant: restaurant, actionButtonMode: actionButtonMode, isLiked: isLiked)

                RestaurantCardView(presenter: presenter) {
                  selectUsecase.toggleSelectState(restaurant: restaurant)
                } _: {
                  likeUsecase.toggleLikeState(restaurant: restaurant)
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
