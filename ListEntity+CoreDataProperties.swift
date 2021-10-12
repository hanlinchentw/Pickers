//
//  ListEntity+CoreDataProperties.swift
//  
//
//  Created by 陳翰霖 on 2021/10/10.
//
//

import Foundation
import CoreData


extension ListEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListEntity> {
        return NSFetchRequest<ListEntity>(entityName: "ListEntity")
    }

    @NSManaged public var date: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var restaurants: NSSet?

}

// MARK: Generated accessors for restaurants
extension ListEntity {

    @objc(addRestaurantsObject:)
    @NSManaged public func addToRestaurants(_ value: SavedRestaurant)

    @objc(removeRestaurantsObject:)
    @NSManaged public func removeFromRestaurants(_ value: SavedRestaurant)

    @objc(addRestaurants:)
    @NSManaged public func addToRestaurants(_ values: NSSet)

    @objc(removeRestaurants:)
    @NSManaged public func removeFromRestaurants(_ values: NSSet)

}
