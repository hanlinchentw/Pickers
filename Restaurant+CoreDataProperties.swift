//
//  Restaurant+CoreDataProperties.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/10/1.
//  Copyright © 2022 陳翰霖. All rights reserved.
//
//

import Foundation
import CoreData


extension Restaurant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
    }

    @NSManaged public var businessCategory: String?
    @NSManaged public var distance: Double
    @NSManaged public var id: String
    @NSManaged public var imageUrl: String?
    @NSManaged public var isClosed: Bool
    @NSManaged public var isLiked: Bool
    @NSManaged public var isSelected: Bool
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String
    @NSManaged public var price: String
    @NSManaged public var rating: Double
    @NSManaged public var reviewCount: Int32
    @NSManaged public var like: LikedRestaurant?
    @NSManaged public var list: NSSet?
    @NSManaged public var select: SelectedRestaurant?

}

// MARK: Generated accessors for list
extension Restaurant {

    @objc(addListObject:)
    @NSManaged public func addToList(_ value: List)

    @objc(removeListObject:)
    @NSManaged public func removeFromList(_ value: List)

    @objc(addList:)
    @NSManaged public func addToList(_ values: NSSet)

    @objc(removeList:)
    @NSManaged public func removeFromList(_ values: NSSet)

}

extension Restaurant : Identifiable {
  convenience init(business: Business, context: NSManagedObjectContext = CoreDataManager.sharedInstance.managedObjectContext) {
    let entity = NSEntityDescription.entity(forEntityName: "Restaurant", in: context)!
    self.init(entity: entity, insertInto: context)
    self.id = business.id
    self.name = business.name
    self.imageUrl = business.imageUrl
    self.reviewCount = Int32(business.reviewCount)
    self.rating = business.rating
    self.price = business.price ?? ""
    self.businessCategory = business.categories[safe: 0]?.title
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
    self.imageUrl = detail.imageUrl
    self.reviewCount = Int32(detail.reviewCount)
    self.rating = detail.rating
    self.price = detail.price ?? ""
    self.businessCategory = detail.categories[safe: 0]?.title
    self.latitude = detail.coordinates.latitude
    self.longitude = detail.coordinates.longitude
  }
}

extension Restaurant {
  convenience init(restaurant: RestaurantViewObject, context: NSManagedObjectContext = CoreDataManager.sharedInstance.managedObjectContext) {
    let entity = NSEntityDescription.entity(forEntityName: "Restaurant", in: context)!
    self.init(entity: entity, insertInto: context)
    self.id = restaurant.id
    self.name = restaurant.name
    self.imageUrl = restaurant.imageUrl
		self.reviewCount = restaurant.reviewCount == nil ? Int32() : Int32(restaurant.reviewCount!)
		self.rating = restaurant.rating ?? .nan
		self.price = restaurant.price ?? ""
    self.businessCategory = restaurant.businessCategory
		self.latitude = restaurant.latitude ?? .nan
    self.longitude = restaurant.longitude ?? .nan
  }
}

extension Restaurant {
  static func !=(lhs: Restaurant, rhs: Restaurant) -> Bool {
    return lhs.id != rhs.id
  }
}
