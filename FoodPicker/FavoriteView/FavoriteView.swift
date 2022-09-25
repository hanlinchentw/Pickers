//
//  FavoriteView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/20.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI
import Combine

struct FavoriteView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(sortDescriptors: []) var likedRestaurants: FetchedResults<LikedRestaurant>

  // Use cases
  @StateObject var editUsecase = EditFavoriteListUsecase()

  // States
  @State var searchText: String = ""

  var body: some View {
    ZStack {
      Color.listViewBackground.ignoresSafeArea()
      FavoriteHeader()
      ScrollView(.vertical, showsIndicators: false) {
        FavoriteSearchContainer(inputText: $searchText, isEditing: editUsecase.isEditing)

        FavoriteEditButtonContainer(isEditing: $editUsecase.isEditing)

        FavoriteListContainer(
          listData:
            likedRestaurants
            .map { $0.restaurant }
            .filter( { filterListData(name: $0.name) }),
          isEditing: $editUsecase.isEditing,
          deleteButtonOnPress: editUsecase.setDeleteItem
        )
        .environment(\.managedObjectContext, viewContext)
      }
      .safeAreaInset(edge: .top) { Spacer().height(50) }
      .safeAreaInset(edge: .bottom) { Spacer().height(50) }
    }
    .showAlert(when: editUsecase.deletedItem != nil, alert: {
      Alert(model:
          .init(
            title: "Remove from My Favorite",
						content: editUsecase.deletionAlertText,
            rightButtonText: "Remove",
            leftButtonText: "Cancel",
            rightButtonOnPress: editUsecase.removeItem,
            leftButtonOnPress: editUsecase.cancel
          )
      )
    })
    .navigationBarHidden(true)
    .onTapGesture {
      UIResponder.resign()
    }
  }

  func filterListData(name: String) -> Bool {
    if (searchText.isEmpty) { return true }
    let predicate = NSPredicate(format: "SELF CONTAINS %@", searchText.lowercased())
    return predicate.evaluate(with: name.lowercased())
  }
}

struct FavoriteView_Previews: PreviewProvider {
  static var previews: some View {
    FavoriteView()
  }
}

struct FavoriteHeader: View {
  var body: some View {
    VStack() {
      VStack {
        Text("Favorite")
          .en16Bold()
          .padding(.top, 24)
      }
      .frame(width: UIScreen.screenWidth, height: 80)
      .background(Color.white)
      .cornerRadius(32, corners: [.bottomLeft, .bottomRight])
      Spacer()
    }
    .ignoresSafeArea()
    .zIndex(3)
    .id("Header")
  }
}
