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

class MapViewModel: Likable, Selectable {
  @Inject var locationService: LocationService
  @Inject var selectService: SelectedCoreService
  @Inject var likeService: LikedCoreService

  @Published var isRefresh = false
  @Published var updateAnnotation = false
  @Published var numOfSelectRestaurant: Int = 0
  @Published var error: Error? = nil
  @Published var requestUpdateSearchResult = false

  var restaurants: Array<RestaurantViewObject> = []

  var set = Set<AnyCancellable>()

  var userLatitude: Double? {
    return locationService.latitude
  }

  var userLongitude: Double? {
    return locationService.longitude
  }

  init() {
    observeSelectedRestaurantChange()
  }

  func refresh() {
    OperationQueue.main.addOperation {
      if let numOfSelectRestaurant = try? SelectedRestaurant.allIn(CoreDataManager.sharedInstance.managedObjectContext).count {
        self.numOfSelectRestaurant = numOfSelectRestaurant
      }
      self.isRefresh = true
    }
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
          }
        }
        if let delete = delete, let object = delete.first(where: { $0 is SelectedRestaurant}) as? SelectedRestaurant {
          if let index = self.restaurants.firstIndex(where: { $0.id == object.id }) {
            self.restaurants[index].isSelected  = false
          }
        }
        if let insert = insert, let object = insert.first(where: { $0 is LikedRestaurant}) as? LikedRestaurant {
          if let index = self.restaurants.firstIndex(where: { $0.id == object.id }) {
            self.restaurants[index].isLiked = true
          }
        }
        if let delete = delete, let object = delete.first(where: { $0 is LikedRestaurant}) as? LikedRestaurant {
          if let index = self.restaurants.firstIndex(where: { $0.id == object.id }) {
            self.restaurants[index].isLiked  = false
          }
        }
        self.refresh()
      }
      .store(in: &set)
  }

  func fetchRestaurant(latitude: Double? = nil, longitude: Double?) async  {
		print("fetchRestaurant >>> ")
    do {
			guard let latitude = latitude, let longitude = longitude else {
				throw LoactionError.locationNotFound(message: "Location not found")
			}
			var viewObjects = Array<RestaurantViewObject>()
			for offset in 0 ..< 2 {
				let query = BusinessService.Query.init(lat: latitude, lon: longitude, option: .nearyby, limit: 50, offset: offset)
				let businesses = try await BusinessService.fetchBusinesses(query: query)
				for business in businesses {
					var viewObject = RestaurantViewObject(business: business)
					viewObject.isSelected = try selectService.exists(id: business.id, in: CoreDataManager.sharedInstance.managedObjectContext)
					viewObject.isLiked = try likeService.exists(id: business.id, in: CoreDataManager.sharedInstance.managedObjectContext)
					viewObjects.append(viewObject)
				}
			}
      self.restaurants = viewObjects
      self.refresh()
      self.updateAnnotation = true
    } catch {
			print(">>> MapViewModel.\(#function), error=\(error)")
      self.error = error
    }
  }
}
