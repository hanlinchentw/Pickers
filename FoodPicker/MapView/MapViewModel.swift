//
//  MapViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/3.
//  Copyright © 2022 陳翰霖. All rights reserved.
//
import Foundation
import Combine
import CoreLocation
import MapKit

class MapViewModel: ObservableObject {
  @Inject var locationService: LocationService

  @Published var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(
      latitude: 24.97524558,
      longitude: 121.53519691
    ),
    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
  )

  @Published var restaurants: Array<RestaurantViewObject> = []

  @Published var error: Error? = nil

  var annotationItems: Array<AnnotationItem> = []

  var set = Set<AnyCancellable>()

  init() {
    bindLastLocation()
    bindSearchResult()
  }

  func fetchRestaurantNearby() async  {
    guard let latitude = locationService.latitude,
          let longitude = locationService.longitude else {
      error = LoactionError.locationNotFound(message: "Can't find business nearby.")
      return
    }
    do {
      let business = try await BusinessService.fetchBusinesses(lat: latitude, lon: longitude, option: .all, limit: 50)
      self.restaurants = business.map { RestaurantViewObject(business: $0) }
    } catch {

    }
  }
}
// MARK: - Binding
extension MapViewModel {
  func bindLastLocation() {
    locationService.$lastLocation.sink { [weak self] location in
      guard let location = location else {
        return
      }
      self?.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), latitudinalMeters: 3000, longitudinalMeters: 3000)
    }
    .store(in: &set)
  }

  func bindSearchResult() {
    $restaurants.sink { restaurants in
      self.annotationItems = restaurants.map { AnnotationItem(restaurant: $0) }
    }
    .store(in: &set)
  }
}
