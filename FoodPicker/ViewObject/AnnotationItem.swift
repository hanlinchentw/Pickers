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
  let name: String

  init(restaurant: RestaurantViewObject) {
    self.id = restaurant.id
    self.name = restaurant.name
    super.init()
    self.coordinate = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
  }
}
