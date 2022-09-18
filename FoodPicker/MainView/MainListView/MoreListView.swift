//
//  MoreListView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/9.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct MoreListView: View {
  @StateObject var viewModel = RestaurantViewModel(option: .nearyby)
  @EnvironmentObject var coordinator: MainCoordinator
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(sortDescriptors: []) var selectedRestaurants: FetchedResults<SelectedRestaurant>

  @State var shouldLoadMore: Bool = true

  var body: some View {
    ZStack {
      Color.listViewBackground
        .ignoresSafeArea()
      VStack {
        MoreRestaurantsHeader(onPress: { coordinator.pop() })

        ScrollView(.vertical, showsIndicators: false) {
          LazyVStack {
            ForEach(0 ..< viewModel.dataSource.viewObjects.count, id: \.self) { index in
              let restaurant = viewModel.dataSource.viewObjects[index]
              let isSelected = selectedRestaurants.contains(where: {$0.id == restaurant.id})
              let actionButtonMode: ActionButtonMode = isSelected ? .select : .deselect
              let presenter = RestaurantPresenter(restaurant: restaurant, actionButtonMode: actionButtonMode)
              RestaurantListItemView(presenter: presenter) {
                viewModel.selectRestaurant(isSelected: isSelected, restaurant: restaurant)
              }
              .padding(.horizontal, 8)
              .onTapGesture {
                coordinator.pushToDetailView(id: restaurant.id)
              }
              .onAppear {
                shouldLoadMore = index == viewModel.dataSource.viewObjects.count - 5
              }
            }
          }
          .padding(.top, 16)

          if shouldLoadMore {
            ProgressView().progressViewStyle(.circular)
              .foregroundColor(.gray)
              .task {
                await viewModel.fetchData(resultCount: 50)
                shouldLoadMore = false
              }
          }
        }
        .coordinateSpace(name: "MoreRestaurantScrollView")
        .safeAreaInset(edge: .bottom, content: { Spacer().height(44) })
        .background(Color.white)
        .cornerRadius(24)
        .edgesIgnoringSafeArea(.bottom)
      }
    }
    .navigationBarHidden(true)
  }
}

struct MoreListView_Previews: PreviewProvider {
  static var previews: some View {
    MoreListView()
  }
}

private struct MoreRestaurantsHeader: View {
  var onPress: () -> Void

  var body: some View {
    HStack {
      RoundedRectangle(cornerRadius: 22)
        .fill(Color.white)
        .overlay(Image("icnArrowBack"))
        .frame(width: 44, height: 44)
        .padding(.leading, 8)
        .onTapGesture {
          onPress()
        }
      Spacer()
    }
    .overlay(
      Text("More restaurants").en16Bold()
    )
  }
}
