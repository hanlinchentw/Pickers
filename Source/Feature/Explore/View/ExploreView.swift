//
//  ExploreView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/1/6.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import CoreLocation
import Observation
import SwiftUI

struct ExploreView: View {
  @Environment(\.modelContext) var context
  @Environment(LocationManager.self) var locationManager
  @State var searchedText = ""
  @State var browseMode: BrowseMode = .list
  @State var priceRange: Double = 0
  @State var isLoading = false
  @State var sortOption: SortOption = .distance
  @State var showFilterSheet = false

  var userAddress: UserAddress?
  var exploreModel: ExploreModel
  var isLocationServiceEnabled: LocationEnabled {
    locationManager.isLocationEnabled
  }

  var body: some View {
    ZStack {
      Color.clear
      if let location = userAddress?.location {
        placeBrowserView(location: location, address: userAddress?.postalAddress)
      } else if let location = locationManager.currLocation,
                let address = UserAddress(cllocation: location) {
        placeBrowserView(location: location.coordinate, address: address.postalAddress)
      } else {
        LocationNotFoundView(isLocationServiceEnabled: isLocationServiceEnabled)
      }
    }
  }

  @ViewBuilder
  func placeBrowserView(
    location: CLLocationCoordinate2D,
    address: String?
  ) -> some View {
    VStack {
      ExploreHeaderView(
        address: address,
        browseMode: $browseMode,
        searchText: $searchedText,
        onClickFilterButton: onClickFilterButton
      )

      ZStack {
        ExploreMapView().if(browseMode != .map) { $0.opacity(0) }
        ExploreMainScrollView(
          viewModels: exploreModel.viewModels,
          isLoading: isLoading,
          onClickHeart: { exploreModel.onClickLikeButton($0) },
          onClickSelect: { exploreModel.onClickSelectButton(viewModel: $0) },
          loadMoreIfNeeded: {
            await exploreModel.fetchMore(location: location)
          },
          shouldLoadMore: { index in
            exploreModel.hasMoreToLoad && exploreModel.reachEnd(index: index)
          },
          refresh: {
            await exploreModel.fetch(location: location)
          }
        )
        .safeAreaPadding(.bottom, 100)
        .offset(y: browseMode == .map ? UIScreen.height : 0)
      }
    }
    .task {
      isLoading = true
      if exploreModel.viewModels.isEmpty {
        await exploreModel.fetch(location: location)
      }
      isLoading = false
    }
    .sheet(isPresented: $showFilterSheet) {
      Text("Filter")
    }
  }

  func onClickFilterButton() {
    showFilterSheet = true
  }
}

extension PlaceViewModel: Identifiable {}

#if DEBUG
struct ExploreView_Previews: PreviewProvider {
  static let container = DependencyContainer.shared.getPreviewPlaceModelContainer().modelContainer
  static var previews: some View {
    ExploreView(
      userAddress: .init(
        latitude: 0,
        longitude: 0,
        postalAddress: "中山北路, 43 號"
      ),
      exploreModel: .init()
    )
    .modelContainer(container)
  }
}

struct ExploreViewLocationNotFoundPreviews: PreviewProvider {
  static let container = DependencyContainer.shared.getPreviewPlaceModelContainer().modelContainer
  static var previews: some View {
    ExploreView(
      userAddress: .init(),
      exploreModel: .init()
    )
    .modelContainer(container)
  }
}

struct PlaceRepositoryPreview: PlaceRepository {
  var isLoading: Bool { false }

  var hasMoreToLoad: Bool { true }

  func fetchMore(config: PlaceSearchConfig) async throws -> [Business] {
    [Business](repeating: dummyBusiness, count: 10)
  }

  func fetch(config: PlaceSearchConfig) async throws -> [Business] {
    [Business](repeating: dummyBusiness, count: 10)
  }

  var dummyBusiness: Business {
    .init(
      id: UUID().uuidString,
      name: "Apple",
      rating: 5.0,
      price: "$$$",
      imageUrl: Constants.defaultImageURL,
      distance: 125,
      isClosed: false,
      categories: ["Food"],
      reviewCount: 12555,
      coordinates: .init(latitude: 23.5, longitude: 123.2)
    )
  }
}
#endif
