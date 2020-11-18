//
//  RestaurantAnnotation.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/11/17.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import Foundation
import MapKit

class RestaurantAnnotation: MKPointAnnotation{
    let id : String
    var index: Int?
    
    init(id: String) {
        self.id = id
    }
}
