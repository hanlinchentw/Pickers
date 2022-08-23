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

  var data: Array<Restaurant> {
    return likedRestaurants.map { $0.restaurant }
      .filter({ restaurant in
        if (searchText.isEmpty) { return true }
        let pred = NSPredicate(format: "SELF CONTAINS %@", searchText.lowercased())
        return pred.evaluate(with: restaurant.name.lowercased())
      })
  }

  var body: some View {
    ZStack {
      Color.listViewBackground.ignoresSafeArea()
      FavoriteHeader()
      ScrollView(.vertical, showsIndicators: false) {
        FavoriteSearchContainer(inputText: $searchText, isEditing: editUsecase.isEditing)

        FavoriteEditButtonContainer(isEditing: $editUsecase.isEditing)

        FavoriteListContainer(
          listData: data,
          isEditing: $editUsecase.isEditing,
          deleteButtonOnPress: editUsecase.setDeleteItem
        )
      }
      .safeAreaInset(edge: .top) { Spacer().height(50) }
      .safeAreaInset(edge: .bottom) { Spacer().height(50) }
    }
    .showAlert(when: editUsecase.deletedItem != nil, alert: {
      Alert(
        title: "Remove from My Favorite",
        rightButtonText: "Remove",
        leftButtonText: "Cancel",
        rightButtonOnPress: editUsecase.removeItemFromFavorite,
        leftButtonOnPress: editUsecase.cancelDeletion,
        content: {
          Text(editUsecase.deletionAlertText).multilineTextAlignment(.center)
        }
      )
    })
    .navigationBarHidden(true)
    .onTapGesture {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
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
          .en16ArialBold()
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
