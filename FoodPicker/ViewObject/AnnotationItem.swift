//
//  RestaurantAnnotation.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/11/17.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import Foundation
import MapKit

class AnnotationItem: MKPointAnnotation {
  let id: String
  var indexForCollectionView: Int? = nil

	init(restaurant: RestaurantViewObject, lat: Double, lon: Double) {
    self.id = restaurant.id
    super.init()
    self.title = restaurant.name
    self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
  }
}
