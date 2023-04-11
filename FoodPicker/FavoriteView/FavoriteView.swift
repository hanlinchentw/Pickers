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
  // States
  @State var searchText: String = ""

  var body: some View {
    ZStack {
      Color.listViewBackground.ignoresSafeArea()
      FavoriteHeader()
      ScrollView(.vertical, showsIndicators: false) {
				Text("Favorite")
					.foregroundColor(.black)
      }
      .safeAreaInset(edge: .top) { Spacer().height(50) }
      .safeAreaInset(edge: .bottom) { Spacer().height(50) }
    }
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
					.padding(.top, SafeAreaUtils.top)
      }
      .frame(width: UIScreen.screenWidth, height: 100)
      .background(Color.white)
      .cornerRadius(32, corners: [.bottomLeft, .bottomRight])
      Spacer()
    }
    .ignoresSafeArea()
    .zIndex(3)
    .id("Header")
  }
}
