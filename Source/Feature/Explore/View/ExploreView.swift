//
//  ExploreView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/1/6.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import CoreLocation
import Defaults
import Observation
import SwiftData
import SwiftUI

struct ExploreView: View {
  @Environment(\.modelContext)
  private var context
	@Environment(LocationManager.self)
	private var locationManager

  @State private var searchedText = ""
  @State private var browseMode: BrowseMode = .list
  @State private var priceRange: Double = 0
  @State private var isLoading = false
  @State private var sortOption: SortOption = .distance
  @State private var showFilterSheet = false
	
	@Query private var addresses: [UserAddress]
	@AppStorage(Defaults.Keys.currentAddressId.name)
	var currentAddressId: String?

	@Bindable var exploreModel: ExploreModel

	let onSelectPlace: (PlaceViewModel) -> Void

	var currentAddress: UserAddress? {
		if let address = addresses.first(where: {
			$0.id == currentAddressId
		}) {
			return address
		}
		return addresses.first
	}

  var body: some View {
    ZStack {
      Color.clear
			let status = locationManager.getLocationAuthStatus()
			if let address = currentAddress, let location = address.location {
				placeBrowserView(
					location: location,
					address: address.postalAddress
				)
			} else if status == .disabled {
				LocationNotFoundView()
			} else {
				ProgressView()
			}
    }
		.onAppear {
			locationManager.askPermissionIfNeeded()
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
				location: location,
        browseMode: $browseMode,
        searchText: $searchedText,
        onClickFilterButton: onClickFilterButton,
				onPressAddress: {
					Task {
						await exploreModel.fetch(location: location)
					}
				}
      )

      ZStack {
        ExploreMapView().if(browseMode != .map) { $0.opacity(0) }
        ExploreMainScrollView(
					currentLocation: location,
          viewModels: exploreModel.viewModels,
          isLoading: isLoading,
					hasMoreToLoad: exploreModel.hasMoreToLoad,
          onClickHeart: exploreModel.onClickLikeButton,
					onClickSelect: onSelectPlace,
          loadMoreIfNeeded: {
            await exploreModel.fetchMore(location: location)
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
			await exploreModel.fetch(location: location)
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
  static var previews: some View {
    ExploreView(
			exploreModel: .init(placeRepository: PlaceRepositoryPreview())
		) { _ in }
    .dummySwiftDataModelContainer()
		.environment(LocationManager())
  }
}

struct ExploreViewLocationNotFoundPreviews: PreviewProvider {
  static var previews: some View {
    ExploreView(
			exploreModel: .init(placeRepository: PlaceRepositoryPreview())
		) { _ in }
    .dummySwiftDataModelContainer()
		.environment(LocationManager())
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
			categories: [.init(title: "Food")],
      reviewCount: 12555,
      coordinates: .init(latitude: 23.5, longitude: 123.2),
			location: Location(displayAddress: ["EmeryVile"])
    )
  }
}
#endif
