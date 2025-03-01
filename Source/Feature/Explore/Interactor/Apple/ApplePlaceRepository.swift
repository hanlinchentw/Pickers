//
//  ApplePlaceRepository.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/10/5.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import CoreLocation
import Foundation
import MapKit

final class ApplePlaceRepository: PlaceRepository {
  var locationManager: LocationManager

  var isLoading: Bool = false

  var hasMoreToLoad: Bool = false

  var categoriesRelatedToFood: [MKPointOfInterestCategory] {
    [.bakery, .brewery, .cafe, .foodMarket, .restaurant, .nightlife, .store]
  }

  init(locationManager: LocationManager) {
    self.locationManager = locationManager
  }

  func fetch(config: PlaceSearchConfig) async throws -> [Business] {
    let categories = config.categories.map { MKPointOfInterestCategory(rawValue: $0.rawValue) }
    let mapItems = try await searchPlaces(
      location: config.location,
      radius: config.radius,
      keyword: config.keyword,
      categories: categories
    )
    return mapItems.map { Business(from: $0) }
  }

  func fetchMore(config: PlaceSearchConfig) async throws -> [Business] {
    try await fetch(config: config)
  }
}

private extension ApplePlaceRepository {
  func searchPlaces(
    location: CLLocationCoordinate2D? = nil,
    radius: CLLocationDistance,
    keyword: String? = nil,
    categories: [MKPointOfInterestCategory]?
  ) async throws -> [MKMapItem] {
    let request = MKLocalSearch.Request()

    if let keyword {
      request.naturalLanguageQuery = keyword
    }

    if let location {
      request.region = MKCoordinateRegion(center: location, latitudinalMeters: radius, longitudinalMeters: radius)
    } else if let userLocation = locationManager.currLocation?.coordinate {
      request.region = MKCoordinateRegion(center: userLocation, latitudinalMeters: radius, longitudinalMeters: radius)
    }

    if let categories {
      request.pointOfInterestFilter = MKPointOfInterestFilter(including: categories)
    }

    let search = MKLocalSearch(request: request)
    let response = try await search.start()
    return response.mapItems
  }
}
