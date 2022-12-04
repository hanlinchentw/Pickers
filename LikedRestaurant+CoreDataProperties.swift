//
//  LikedRestaurant+CoreDataProperties.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/12.
//  Copyright © 2022 陳翰霖. All rights reserved.
//
//

import Foundation
import CoreData


extension LikedRestaurant: RestaurantManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikedRestaurant> {
        return NSFetchRequest<LikedRestaurant>(entityName: "LikedRestaurant")
    }

    @NSManaged public var id: String
    @NSManaged public var restaurant: Restaurant

}

extension LikedRestaurant : Identifiable {
  convenience init(restaurant: Restaurant, in context: NSManagedObjectContext = CoreDataManager.sharedInstance.managedObjectContext) {
    let entity = NSEntityDescription.entity(forEntityName: "Restaurant", in: context)!
    self.init(entity: entity, insertInto: context)
    self.id = restaurant.id
    self.restaurant = restaurant
  }
}
