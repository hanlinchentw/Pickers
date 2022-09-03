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
import CoreData

class MapViewModel {
  @Inject var locationService: LocationService
  @Inject var selectService: SelectedCoreService

  @Published var isRefresh = false

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
    localSearch()
  }

  func observeSelectedRestaurantChange() {
    NotificationCenter.default.publisher(for: Notification.Name.NSManagedObjectContextObjectsDidChange)
      .sink { notification in
        guard let userInfo = notification.userInfo else { return }
        let insert = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>
        let delete = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>

        if let insert = insert, let object = insert.first(where: { $0 is SelectedRestaurant}) as? SelectedRestaurant {
          if let index = self.restaurants.firstIndex(where: { $0.id == object.id }) {
            self.restaurants[index].isSelected = true
          } else {
            self.restaurants.append(RestaurantViewObject(restaurant: object.restaurant))
          }
        }
        if let delete = delete, let object = delete.first(where: { $0 is SelectedRestaurant}) as? SelectedRestaurant {
          if let index = self.restaurants.firstIndex(where: { $0.id == object.id }) {
            self.restaurants[index].isSelected  = false
          }
        }
        self.isRefresh = true
      }
      .store(in: &set)
  }

    func didTapSelectButton(_ target: RestaurantViewObject) {
      guard let restaurant = restaurants.first(where: { $0.id == target.id }) else {
        return
      }

      if restaurant.isSelected {
        try? selectService.deleteRestaurant(id: restaurant.id, in: CoreDataManager.sharedInstance.managedObjectContext)
      } else {
        let restaurantManagedObject = Restaurant(restaurant: target)
        try? selectService.addRestaurant(data: ["restaurant": restaurantManagedObject], in: CoreDataManager.sharedInstance.managedObjectContext)
      }
    }

    func localSearch() {
      let request = MKLocalSearch.Request()
      request.region = region
      let search = MKLocalSearch(request: request)
      search.start { response, error in
        print(response)
      }
    }

    func fetchRestaurantNearby() async  {
      guard let latitude = locationService.latitude,
            let longitude = locationService.longitude else {
        error = LoactionError.locationNotFound(message: "Can't find business nearby.")
        return
      }
      do {
        let businesses = try await BusinessService.fetchBusinesses(lat: latitude, lon: longitude, option: .all, limit: 50)

        var viewObjects = Array<RestaurantViewObject>()
        for business in businesses {
          var viewObject = RestaurantViewObject(business: business)
          viewObject.isSelected = try selectService.exists(id: business.id, in: CoreDataManager.sharedInstance.managedObjectContext)
          viewObjects.append(viewObject)
        }
        self.restaurants = viewObjects
        self.isRefresh = true
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
