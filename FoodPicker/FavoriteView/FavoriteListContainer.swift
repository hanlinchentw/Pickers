//
//  FavoriteList.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/21.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct FavoriteListContainer: View {
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(sortDescriptors: []) var selectedRestaurants: FetchedResults<SelectedRestaurant>

  var listData: Array<Restaurant>
  @Binding var isEditing: Bool
  var deleteButtonOnPress: (_ item: Restaurant) -> Void

  var viewModel = FavoriteListViewModel()

  var body: some View {
    VStack(spacing: 16) {
      ForEach(listData, id: \.self) { restaurant in
        let actionBtnMode = viewModel.getActionButtonMode(isEditing: isEditing, restaurantId: restaurant.id)
        let presenter = RestaurantPresenter(restaurant: restaurant, actionButtonMode: actionBtnMode)

        RestaurantListItemView(presenter: presenter, actionButtonOnPress: {
          if isEditing {
            deleteButtonOnPress(restaurant)
          } else {
            viewModel.selectButtonOnPress(restaurant: restaurant)
          }
        })
        .padding(.horizontal, 12)
      }
    }
  }
}

class FavoriteListViewModel: ObservableObject {
  @Inject var selectedCoreService: SelectedCoreService
  static let viewContext = CoreDataManager.sharedInstance.managedObjectContext

  func selectButtonOnPress(restaurant: Restaurant) {
    let isSelected = try? selectedCoreService.exists(id: restaurant.id, in: Self.viewContext)
    if let isSelected = isSelected, isSelected {
      try! selectedCoreService.deleteRestaurant(id: restaurant.id, in: Self.viewContext)
    } else {
      try! selectedCoreService.addRestaurant(data: ["restaurant": restaurant], in: Self.viewContext)
    }
  }

  func getActionButtonMode(isEditing: Bool, restaurantId: String) -> ActionButtonMode {
    if isEditing { return .edit }

    guard let isSelected = try? selectedCoreService.exists(id: restaurantId, in: Self.viewContext) else {
      return .deselect
    }

    return isSelected ? .select : .deselect
  }
}
