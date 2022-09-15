//
//  HorizontalRestaurantCollectionContainer.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/13.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct HorizontalSectionContainer: View {
  @StateObject var dataStore = HorizontalSectionDataStore()

  @EnvironmentObject var coordinator: MainCoordinator
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(sortDescriptors: []) var selectedRestaurants: FetchedResults<SelectedRestaurant>
  @FetchRequest(sortDescriptors: []) var likedRestaurants: FetchedResults<LikedRestaurant>

  @Inject var selectedCoreService: SelectedCoreService
  @Inject var likedCoreService: LikedCoreService
  @Inject var locationService: LocationService
  
  var showContent: Bool {
    dataStore.loadState != LoadingState.empty && dataStore.loadState != LoadingState.error
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {

      if (showContent) {
        Text(BusinessService.RestaurantSorting.popular.description)
          .en24Bold()
          .padding(.leading, 16)
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 16) {
            ForEach(0 ..< dataStore.dataCount, id: \.self) { index in
              if dataStore.loadState != LoadingState.loaded {
                DummyRestaurantCardView()
                  .padding(.vertical, 8)
              } else {
                let restaurant = dataStore.data[index]
                let isLiked = likedRestaurants.contains(where: { $0.id == restaurant.id })
                let isSelected = selectedRestaurants.contains(where: { $0.id == restaurant.id })
                let actionButtonMode: ActionButtonMode = isSelected ? .select : .deselect
                let presenter = RestaurantPresenter(restaurant: restaurant, actionButtonMode: actionButtonMode, isLiked: isLiked)

                RestaurantCardView(presenter: presenter) {
                  selectButtonOnPress(isSelected: isSelected, restaurant: restaurant)
                } _: {
                  likeButtonOnPress(isLiked: isLiked, restaurant: restaurant)
                }
                .onTapGesture {
                  coordinator.pushToDetailView(id: restaurant.id)
                }
                .padding(.vertical, 8)
                .buttonStyle(.plain)
              }
            }
          }
          .padding(.leading, 16)
        }
      }
    }
    .task {
      if (dataStore.loadState == LoadingState.loaded) { return }
      await dataStore.fetchData(lat: locationService.latitude, lon: locationService.longitude)
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

  func likeButtonOnPress(isLiked: Bool, restaurant: RestaurantViewObject) {
    if (isLiked) {
      try! likedCoreService.deleteRestaurant(id: restaurant.id, in: viewContext)
    } else {
      let restaurantManagedObject = Restaurant(restaurant: restaurant)
      try! likedCoreService.addRestaurant(data: ["restaurant": restaurantManagedObject], in: viewContext)
    }
  }
}

class HorizontalSectionDataStore: ObservableObject {
  @Inject var restaurantCoreService: RestaurantCoreService

  @Published var data: Array<RestaurantViewObject> = []
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
      let task = BusinessService.createDataTask(lat: latitude, lon: longitude, option: BusinessService.RestaurantSorting.popular, limit: 10)
      let result = try await task.value
      DispatchQueue.main.async {
        self.data = result.map { RestaurantViewObject.init(business: $0) }
        self.loadState = result.isEmpty ? LoadingState.empty : LoadingState.loaded
      }
    } catch {
      loadState = LoadingState.error
      print("HorizontalSectionDataStore.fetchSectionData >>> \(error.localizedDescription)")
    }
  }
}