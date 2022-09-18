//
//  VerticalRestaurantListContainer.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/13.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct NearbySectionView: View {
  @EnvironmentObject var coordinator: MainCoordinator
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(sortDescriptors: []) var selectedRestaurants: FetchedResults<SelectedRestaurant>
  
  @Inject var selectedCoreService: SelectedCoreService
  @Inject var locationService: LocationService
  
  @Binding var data: MainListViewModel.ListSectionData
  var showContent: (_ data: MainListViewModel.ListSectionData) -> Bool
  var dataCount: (_ data: MainListViewModel.ListSectionData) -> Int
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      if showContent(data) {
        Text("Restaurant nearby")
          .en24Bold()
          .padding(.leading, 16)
        VStack(spacing: 16) {
          ForEach(0 ..< dataCount(data), id: \.self) { index in
            if data.loadingState != LoadingState.loaded {
              IdleRestaurantListItemView()
                .padding(.vertical, 8)
                .shimmer()
            } else {
              let restaurant = data.viewObjects[index]
              let isSelected = selectedRestaurants.contains(where: { $0.id == restaurant.id })
              let actionButtonMode: ActionButtonMode = isSelected ? .select : .deselect
              let presenter = RestaurantPresenter(restaurant: restaurant, actionButtonMode: actionButtonMode)
              
              RestaurantListItemView(presenter: presenter) {
                selectButtonOnPress(isSelected: isSelected, restaurant: restaurant)
              }
              .onTapGesture {
                coordinator.pushToDetailView(id: restaurant.id)
              }
              .buttonStyle(.plain)
            }
          }
          Button {
            coordinator.pushToMoreListView()
          } label: {
            HStack {
              Text("More restaurants")
                .foregroundColor(.black)
                .en16Bold()
              Image(systemName: "arrow.right")
                .foregroundColor(.butterScotch)
                .frame(width: 32, height: 32)
            }
          }
          .padding(.vertical, 16)
        }
        .padding(.top, 16)
        .background(Color.white)
        .cornerRadius(24)
        Spacer()
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
}
