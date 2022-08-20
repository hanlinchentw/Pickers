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
  
  @Inject var locationService: LocationService
  @Inject var selectedCoreService: SelectedCoreService
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      if (!dataStore.data.isEmpty) {
        Text(RestaurantSorting.all.description)
          .en24ArialBold()
          .padding(.leading, 16)
        VStack(spacing: 16) {
          ForEach($dataStore.data.indices, id: \.self) { index in
            let restaurant = dataStore.data[index]
            let isSelected = selectedRestaurants.contains(where: { $0.id == restaurant.id })
            let id = restaurant.id
            let presenter = RestaurantPresenter(restaurant: restaurant, isSelected: isSelected)
            NavigationLink {
              DetailContentView(id: restaurant.id).navigationBarHidden(true).ignoresSafeArea()
            } label: {
              RestaurantListItemView(presenter: presenter) {
                selectButtonOnPress(isSelected: isSelected, itemId: id)
              }
            }
            .buttonStyle(.plain)
          }
        }
        .padding(.top, 16)
        .background(Color.white)
        .cornerRadius(24, corners: [.topLeft, .topRight])
        Spacer()
      }
    }.task {
      await dataStore.fetchData(lat: locationService.latitude, lon: locationService.longitude)
    }
  }
  
  func selectButtonOnPress(isSelected: Bool, itemId: String) {
    if (isSelected) {
      try! selectedCoreService.deleteRestaurant(id: itemId, in: viewContext)
    } else {
      try! selectedCoreService.addRestaurant(data: ["id": itemId], in: viewContext)
    }
  }
}

class VerticalListDataStore: ObservableObject {
  @Inject var restaurantCoreService: RestaurantCoreService
  @Published var data: Array<Restaurant> = []

  func fetchData(lat: Double?, lon: Double?) async {
    do {
      guard let latitude = lat, let longitude = lon else {
        throw LoactionError.locationNotFound(message: "Coordinate found nil.")
      }
      let result = try await BusinessService.createDataTask(lat: latitude, lon: longitude, option: RestaurantSorting.all, limit: 30).value
      DispatchQueue.main.async {
        self.data = result.map { Restaurant.init(business: $0)}
      }
    } catch {
      print("VerticalListDataStore.fetchSectionData >>> \(error.localizedDescription)")
    }
  }
}
