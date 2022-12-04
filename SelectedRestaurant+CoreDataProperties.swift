//
//  SelectedRestaurant+CoreDataProperties.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/12.
//  Copyright © 2022 陳翰霖. All rights reserved.
//
//

import Foundation
import CoreData


extension SelectedRestaurant: RestaurantManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SelectedRestaurant> {
        return NSFetchRequest<SelectedRestaurant>(entityName: "SelectedRestaurant")
    }

    @NSManaged public var id: String
    @NSManaged public var restaurant: Restaurant

}

extension SelectedRestaurant : Identifiable {

}
