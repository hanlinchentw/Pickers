//
//  RestaurantAnnotation.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/11/17.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import Foundation
import MapKit

struct AnnotationItem: Identifiable {
  let id: String
  let name: String
  var coordinate: CLLocationCoordinate2D
//  let imageURL : URL
}


extension AnnotationItem {
  init(restaurant: RestaurantViewObject) {
    self.id = restaurant.id
    self.name = restaurant.name
    self.coordinate = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
  }
}
