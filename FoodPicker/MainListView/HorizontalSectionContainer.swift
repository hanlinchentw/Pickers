//
//  HorizontalRestaurantCollectionContainer.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/13.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct HorizontalSectionContainer: View {
  @EnvironmentObject var locationService: LocationService

  @StateObject private var sectionData =  FetchSectionDataUsecase()

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(RestaurantSorting.popular.description)
        .en24ArialBold()
        .padding(.leading, 16)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 16) {
          ForEach(sectionData.data.indices, id: \.self) { index in
            RestaurantCardView(restaurant: $sectionData.data[index])
              .environmentObject(locationService)
              .padding(.vertical, 8)
          }
        }
        .padding(.leading, 16)  
        .task {
          await sectionData.fetchData(lat: locationService.latitude, lon: locationService.longitude)
        }
      }
    }
  }
}

struct HorizontalRestaurantCollectionContainer_Previews: PreviewProvider {
  static var previews: some View {
    HorizontalSectionContainer()
  }
}

class FetchSectionDataUsecase: ObservableObject {

  @Published var data: Array<RestaurantViewObject> = []

  @Inject var businessService: BusinessService

  func fetchData(lat: Double?, lon: Double?) async {
    do {
      guard let latitude = lat, let longitude = lon else {
        throw LoactionError.locationNotFound(message: "Coordinate found nil.")
      }
      let result = try await businessService.fetchBusinesses(lat: latitude, lon: longitude, option: RestaurantSorting.popular)
      print("FetchSectionDataUsecase.success result: \(result)")
      OperationQueue.main.addOperation {
        self.data = result.map { RestaurantViewObject(business: $0)}
      }
    } catch {
      print("FetchSectionDataUsecase.failed error: \(error.localizedDescription)")
    }
  }
}
