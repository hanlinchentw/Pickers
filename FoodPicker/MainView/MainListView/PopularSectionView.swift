//
//  PopularSectionView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/13.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct PopularSectionView: View {
  @EnvironmentObject var coordinator: MainCoordinator
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(sortDescriptors: []) var selectedRestaurants: FetchedResults<SelectedRestaurant>
  @FetchRequest(sortDescriptors: []) var likedRestaurants: FetchedResults<LikedRestaurant>

  @Inject var selectedCoreService: SelectedCoreService
  @Inject var likedCoreService: LikedCoreService

  @Binding var data: MainListViewModel.ListSectionData
  var showContent: (_ data: MainListViewModel.ListSectionData) -> Bool
  var dataCount: (_ data: MainListViewModel.ListSectionData) -> Int

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
                DummyRestaurantCardView()
                  .padding(.vertical, 8)
              } else {
                let restaurant = data.viewObjects[index]
                let isLiked = likedRestaurants.contains(where: { $0.id == restaurant.id })
                let isSelected = selectedRestaurants.contains(where: { $0.id == restaurant.id })
                let actionButtonMode: ActionButtonMode = isSelected ? .select : .deselect
                let presenter = RestaurantPresenter(restaurant: restaurant, actionButtonMode: actionButtonMode, isLiked: isLiked)

                RestaurantCardView(presenter: presenter) {
                  selectButtonOnPress(isSelected: isSelected, restaurant: restaurant)
                } _: {
                  likeButtonOnPress(isLiked: isLiked, restaurant: restaurant)
                }
                .onTapGesture {
                  coordinator.pushToDetailView(id: restaurant.id)
                }
                .padding(.vertical, 8)
                .buttonStyle(.plain)
              }
            }
          }
          .padding(.leading, 16)
        }
      }
    }
  }

  func selectButtonOnPress(isSelected: Bool, restaurant: RestaurantViewObject) {
    if (isSelected) {
      try! selectedCoreService.deleteRestaurant(id: restaurant.id, in: viewContext)
    } else {
      let restaurantManagedObject = Restaurant(restaurant: restaurant)
      try! selectedCoreService.addRestaurant(data: ["restaurant": restaurantManagedObject], in: viewContext)
    }
  }

  func likeButtonOnPress(isLiked: Bool, restaurant: RestaurantViewObject) {
    if (isLiked) {
      try! likedCoreService.deleteRestaurant(id: restaurant.id, in: viewContext)
    } else {
      let restaurantManagedObject = Restaurant(restaurant: restaurant)
      try! likedCoreService.addRestaurant(data: ["restaurant": restaurantManagedObject], in: viewContext)
    }
  }
}
