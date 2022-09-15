//
//  MoreListView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/9.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct MoreListView: View {
  @StateObject var dataStore = MoreListDataStore()
  @EnvironmentObject var coordinator: MainCoordinator
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(sortDescriptors: []) var selectedRestaurants: FetchedResults<SelectedRestaurant>

  @Inject var selectedCoreService: SelectedCoreService
  @Inject var locationService: LocationService

  @State var shouldLoadMore: Bool = true

  var body: some View {
    ZStack {
      Color.listViewBackground
        .ignoresSafeArea()
      VStack {
        MoreRestaurantsHeader(onPress: { coordinator.pop() })

        ScrollView(.vertical, showsIndicators: false) {
          LazyVStack {
            ForEach(0 ..< dataStore.data.count, id: \.self) { index in
              let restaurant = dataStore.data[index]
              let isSelected = selectedRestaurants.contains(where: { $0.id == restaurant.id })
              let actionButtonMode: ActionButtonMode = isSelected ? .select : .deselect
              let presenter = RestaurantPresenter(restaurant: restaurant, actionButtonMode: actionButtonMode)
              RestaurantListItemView(presenter: presenter) {
                selectButtonOnPress(isSelected: isSelected, restaurant: restaurant)
              }
              .padding(.horizontal, 8)
              .onTapGesture {
                coordinator.pushToDetailView(id: restaurant.id)
              }
              .onAppear {
                shouldLoadMore = index == dataStore.data.count - 5
              }
            }
          }
          .padding(.top, 16)

          if shouldLoadMore {
            ProgressView().progressViewStyle(.circular)
              .foregroundColor(.gray)
              .task {
                await dataStore.fetchData(lat: locationService.latitude, lon: locationService.longitude)
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

struct MoreListView_Previews: PreviewProvider {
  static var previews: some View {
    MoreListView()
  }
}

class MoreListDataStore: ObservableObject {
  @Published var data: Array<RestaurantViewObject> = []
  @Published var loadState: LoadingState = .idle
  @Published var pageIndex = 0

  @MainActor func fetchData(lat: Double?, lon: Double?) async {
    print("pageIndex >>> \(pageIndex)")
    loadState = LoadingState.loading
    do {
      guard let latitude = lat, let longitude = lon else {
        throw LoactionError.locationNotFound(message: "Coordinate found nil.")
      }
      let result = try await BusinessService.createDataTask(lat: latitude, lon: longitude, option: BusinessService.RestaurantSorting.all, limit: 50, offset: pageIndex * 50).value
      pageIndex += 1
      DispatchQueue.main.async {
        self.data += result.map { RestaurantViewObject.init(business: $0)}
        self.loadState = result.isEmpty ? LoadingState.empty : LoadingState.loaded
      }
    } catch {
      loadState = LoadingState.error
      print("MoreListDataStore.fetchSectionData >>> \(error.localizedDescription)")
    }
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