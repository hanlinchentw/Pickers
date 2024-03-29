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
  @Inject var locationManager: LocationManagerProtocol
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
		locationManager.lastLocation?.latitude
  }

  var userLongitude: Double? {
		locationManager.lastLocation?.longitude
  }

  init() {
    observeContextObjectsChange()
  }

	func refresh() {
		OperationQueue.main.addOperation {
			if let numOfSelectRestaurant = try? SelectedRestaurant.allIn(CoreDataManager.sharedInstance.managedObjectContext).count {
				self.numOfSelectRestaurant = numOfSelectRestaurant
			}
			self.isRefresh = true
		}
	}

  func fetchRestaurant(latitude: Double?, longitude: Double?) async  {
    do {
			guard let latitude = latitude, let longitude = longitude else {
				throw LoactionError.locationNotFound(message: "Location not found")
			}
			var viewObjects = Array<RestaurantViewObject>()
			for offset in 0 ..< 2 {
				let query = Query.init(lat: latitude, lon: longitude, option: .nearyby, limit: 50, offset: 50 * offset)
				let businesses = try await BusinessService.fetchBusinesses(query: query)
				for business in businesses {
					if viewObjects.contains(where: { $0.id == business.id }) { return }
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

extension MapViewModel: RestaurantContextDidChangeNotify {
	var selectContextDidInsert: ((SelectedRestaurant) -> Void)? {
		{ object in
			if let index = self.restaurants.firstIndex(where: { $0.id == object.id }) {
				self.restaurants[index].isSelected = true
				self.refresh()
			}
		}
	}
	
	var selectContextDidDelete: ((SelectedRestaurant) -> Void)? {
		{ object in
			if let index = self.restaurants.firstIndex(where: { $0.id == object.id }) {
				self.restaurants[index].isSelected = false
				self.refresh()
			}
		}
	}
	
	var likeContextDidInsert: ((LikedRestaurant) -> Void)? {
		{ object in
			if let index = self.restaurants.firstIndex(where: { $0.id == object.id }) {
				self.restaurants[index].isLiked = true
				self.refresh()
			}
		}
	}
	
	var likeContextDidDelete: ((LikedRestaurant) -> Void)? {
		{ object in
			if let index = self.restaurants.firstIndex(where: { $0.id == object.id }) {
				self.restaurants[index].isLiked = false
				self.refresh()
			}
		}
	}
}
