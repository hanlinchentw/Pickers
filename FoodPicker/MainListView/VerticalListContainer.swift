//
//  VerticalRestaurantListContainer.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/13.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct VerticalListContainer: View {
  @StateObject var dataStore = VerticalListDataStore()

  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(sortDescriptors: []) var selectedRestaurants: FetchedResults<SelectedRestaurant>
  
  @Inject var selectedCoreService: SelectedCoreService
  @Inject var locationService: LocationService

  var showContent: Bool {
    dataStore.loadState != LoadingState.empty && dataStore.loadState != LoadingState.error
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      if showContent {
        Text(BusinessService.RestaurantSorting.all.description)
          .en24Bold()
          .padding(.leading, 16)
        VStack(spacing: 16) {
          ForEach(0 ..< dataStore.dataCount, id: \.self) { index in
            if dataStore.loadState != LoadingState.loaded {
              IdleRestaurantListItemView()
                .padding(.vertical, 8)
                .shimmer()
            } else {
              let restaurant = dataStore.data[index]
              let isSelected = selectedRestaurants.contains(where: { $0.id == restaurant.id })
              let actionButtonMode: ActionButtonMode = isSelected ? .select : .deselect
              let presenter = RestaurantPresenter(restaurant: restaurant, actionButtonMode: actionButtonMode)

              NavigationLink {
                DetailContentView(id: restaurant.id).navigationBarHidden(true).ignoresSafeArea()
              } label: {
                RestaurantListItemView(presenter: presenter) {
                  selectButtonOnPress(isSelected: isSelected, restaurant: restaurant)
                }
              }
              .buttonStyle(.plain)
            }
          }
        }
        .padding(.top, 16)
        .background(Color.white)
        .cornerRadius(24, corners: [.topLeft, .topRight])
        Spacer()
      }
    }
    .task {
      if (dataStore.loadState == LoadingState.loaded) { return }
      await dataStore.fetchData(lat: locationService.latitude, lon: locationService.longitude)
    }
  }
  
  func selectButtonOnPress(isSelected: Bool, restaurant: Restaurant) {
    if (isSelected) {
      try! selectedCoreService.deleteRestaurant(id: restaurant.id, in: viewContext)
    } else {
      try! selectedCoreService.addRestaurant(data: ["restaurant": restaurant], in: viewContext)
    }
  }
}

class VerticalListDataStore: ObservableObject {
  @Inject var restaurantCoreService: RestaurantCoreService

  @Published var data: Array<Restaurant> = []
  @Published var loadState: LoadingState = .idle

  var dataCount: Int {
    return loadState != LoadingState.loaded ? 10 : data.count
  }

  @MainActor func fetchData(lat: Double?, lon: Double?) async {
    loadState = LoadingState.loading
    do {
      guard let latitude = lat, let longitude = lon else {
        throw LoactionError.locationNotFound(message: "Coordinate found nil.")
      }
      let result = try await BusinessService.createDataTask(lat: latitude, lon: longitude, option: BusinessService.RestaurantSorting.all, limit: 30).value
      DispatchQueue.main.async {
        self.data = result.map { Restaurant.init(business: $0)}
        self.loadState = result.isEmpty ? LoadingState.empty : LoadingState.loaded
      }
    } catch {
      loadState = LoadingState.error
      print("VerticalListDataStore.fetchSectionData >>> \(error.localizedDescription)")
    }
  }
}
