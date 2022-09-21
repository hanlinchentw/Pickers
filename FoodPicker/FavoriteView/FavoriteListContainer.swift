//
//  FavoriteList.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/21.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI
import CoreData

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
        let viewObject = RestaurantViewObject(restaurant: restaurant)
        let presenter = RestaurantPresenter(restaurant: viewObject, actionButtonMode: actionBtnMode)

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

class FavoriteListViewModel: ObservableObject, Selectable {
  @Inject var selectService: SelectedCoreService
  private var viewContext: NSManagedObjectContext {
    return CoreDataManager.sharedInstance.managedObjectContext
  }

  func selectButtonOnPress(restaurant: Restaurant) {
    if let isSelected = try? selectService.exists(id: restaurant.id, in: viewContext) {
			selectRestaurant(isSelected: isSelected, restaurant: .init(restaurant: restaurant))
    }
  }

  func getActionButtonMode(isEditing: Bool, restaurantId: String) -> ActionButtonMode {
    if isEditing { return .edit }

    guard let isSelected = try? selectService.exists(id: restaurantId, in: viewContext) else {
      return .deselect
    }

    return isSelected ? .select : .deselect
  }
}
