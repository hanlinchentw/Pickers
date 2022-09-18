//
//  MainListView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/12.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI
import CoreData

enum LoadingState {
  case idle
  case loading
  case loaded
  case error
}

struct MainListView: View {
  @EnvironmentObject var coordinator: MainCoordinator
  @Environment(\.managedObjectContext) private var viewContext
  @State var isSearching = false
  @State var searchText = ""
  @StateObject var popularViewModel = RestaurantViewModel(option: .popular)
  @StateObject var nearbyViewModel = RestaurantViewModel(option: .nearyby)

  var body: some View {
    ZStack {
      Color.listViewBackground.ignoresSafeArea()
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 24) {
          MainListHeader(
            searchText: $searchText,
            isSearching: $isSearching
          )
          .environmentObject(coordinator)

          PopularSectionView()
          .environment(\.managedObjectContext, viewContext)
          .environmentObject(coordinator)
          .environmentObject(popularViewModel)

          NearbySectionView()
          .environment(\.managedObjectContext, viewContext)
          .environmentObject(coordinator)
          .environmentObject(nearbyViewModel)
        }
      }
    }
    .task {
      await popularViewModel.fetchData(resultCount: 10)
      await nearbyViewModel.fetchData(resultCount: 30)
    }
    .navigationBarHidden(true)
    .onTapToResign()
  }
}

struct MainListView_Previews: PreviewProvider {
  static var previews: some View {
    MainListView()
  }
}
