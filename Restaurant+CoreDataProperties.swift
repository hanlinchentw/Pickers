//
//  Restaurant+CoreDataProperties.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/14.
//  Copyright © 2022 陳翰霖. All rights reserved.
//
//

import Foundation
import CoreData


extension Restaurant: RestaurantManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
    }

    @NSManaged public var businessCategory: String
    @NSManaged public var id: String
    @NSManaged public var imageUrl: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var distance: Double
    @NSManaged public var name: String
    @NSManaged public var price: String
    @NSManaged public var rating: Double
    @NSManaged public var reviewCount: Int32
    @NSManaged public var isLiked: Bool
    @NSManaged public var isSelected: Bool
    @NSManaged public var isClosed: Bool

}

extension Restaurant : Identifiable {
  convenience init(business: Business, context: NSManagedObjectContext = CoreDataManager.sharedInstance.managedObjectContext) {
    let entity = NSEntityDescription.entity(forEntityName: "Restaurant", in: context)!
    self.init(entity: entity, insertInto: context)
    self.id = business.id
    self.name = business.name
    self.imageUrl = business.imageUrl ?? Constants.defaultImageURL
    self.reviewCount = Int32(business.reviewCount)
    self.rating = business.rating
    self.price = business.price ?? "-"
    self.businessCategory = business.categories[safe: 0]?.title ?? "Cusine"
    self.latitude = business.coordinates.latitude
    self.longitude = business.coordinates.longitude
  }
}

extension Restaurant {
  convenience init(detail: Detail, context: NSManagedObjectContext = CoreDataManager.sharedInstance.managedObjectContext) {
    let entity = NSEntityDescription.entity(forEntityName: "Restaurant", in: context)!
    self.init(entity: entity, insertInto: context)
    self.id = detail.id
    self.name = detail.name
    self.imageUrl = detail.imageUrl ?? Constants.defaultImageURL
    self.reviewCount = Int32(detail.reviewCount)
    self.rating = detail.rating
    self.price = detail.price ?? "-"
    self.businessCategory = detail.categories[safe: 0]?.title ?? "Cusine"
    self.latitude = detail.coordinates.latitude
    self.longitude = detail.coordinates.longitude
  }
}
