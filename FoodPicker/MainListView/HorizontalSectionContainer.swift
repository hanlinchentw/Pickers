//
//  HorizontalRestaurantCollectionContainer.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/13.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct HorizontalSectionContainer: View {
  @StateObject var dataSotre = HorizontalSectionDataStore()

  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(sortDescriptors: []) var selectedRestaurants: FetchedResults<SelectedRestaurant>
  @FetchRequest(sortDescriptors: []) var likedRestaurants: FetchedResults<LikedRestaurant>

  @Inject var locationService: LocationService
  @Inject var selectedCoreService: SelectedCoreService
  @Inject var likedCoreService: LikedCoreService

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      if (!dataSotre.data.isEmpty) {
        Text(RestaurantSorting.popular.description)
          .en24ArialBold()
          .padding(.leading, 16)
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 16) {
            ForEach($dataSotre.data.indices, id: \.self) { index in
              let restaurant = dataSotre.data[index]
              let isLiked = likedRestaurants.contains(where: { $0.id == restaurant.id })
              let isSelected = selectedRestaurants.contains(where: { $0.id == restaurant.id })
              let presenter = RestaurantPresenter(restaurant: restaurant, isSelected: isSelected, isLiked: isLiked)

              NavigationLink {
                DetailContentView(id: restaurant.id).navigationBarHidden(true).ignoresSafeArea()
              } label: {
                RestaurantCardView(presenter: presenter) {
                  selectButtonOnPress(isSelected: isSelected, itemId: restaurant.id)
                } _: {
                  likeButtonOnPress(isLiked: isLiked, itemId: restaurant.id)
                }
                .padding(.vertical, 8)
              }
              .buttonStyle(.plain)
            }
          }
          .padding(.leading, 16)
        }
      }
    }
    .task {
      await dataSotre.fetchData(lat: locationService.latitude, lon: locationService.longitude)
    }
  }

  func selectButtonOnPress(isSelected: Bool, itemId: String) {
    if (isSelected) {
      try! selectedCoreService.deleteRestaurant(id: itemId, in: viewContext)
    } else {
      try! selectedCoreService.addRestaurant(data: ["id": itemId], in: viewContext)
    }
  }

  func likeButtonOnPress(isLiked: Bool, itemId: String) {
    if (isLiked) {
      try! likedCoreService.deleteRestaurant(id: itemId, in: viewContext)
    } else {
      try! likedCoreService.addRestaurant(data: ["id": itemId], in: viewContext)
    }
  }
}

class HorizontalSectionDataStore: ObservableObject {
  @Inject var restaurantCoreService: RestaurantCoreService
  @Published var data: Array<Restaurant> = []

  func fetchData(lat: Double?, lon: Double?) async {
    do {
      guard let latitude = lat, let longitude = lon else {
        throw LoactionError.locationNotFound(message: "Coordinate found nil.")
      }
      let result = try await BusinessService.createDataTask(lat: latitude, lon: longitude, option: RestaurantSorting.popular, limit: 10).value
      DispatchQueue.main.async {
        self.data = result.map { Restaurant.init(business: $0)}
      }
    } catch {
      print("HorizontalSectionDataStore.fetchSectionData >>> \(error.localizedDescription)")
    }
  }
}
