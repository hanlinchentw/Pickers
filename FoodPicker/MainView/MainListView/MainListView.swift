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
  @ObservedObject var viewModel = MainListViewModel()

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

          PopularSectionView(
            data: $viewModel.popularDataSource,
            showContent: viewModel.showContent,
            dataCount: viewModel.dataCount
          )
          .environment(\.managedObjectContext, viewContext)
          .environmentObject(coordinator)

          NearbySectionView(
            data: $viewModel.nearybyDataSource,
            showContent: viewModel.showContent,
            dataCount: viewModel.dataCount
          )
          .environment(\.managedObjectContext, viewContext)
          .environmentObject(coordinator)
        }
      }
    }
    .task { await viewModel.fetchData() }
    .navigationBarHidden(true)
    .onTapToResign()
  }
}

struct MainListView_Previews: PreviewProvider {
  static var previews: some View {
    MainListView()
  }
}
