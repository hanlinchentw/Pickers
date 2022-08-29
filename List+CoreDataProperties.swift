//
//  List+CoreDataProperties.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/28.
//  Copyright © 2022 陳翰霖. All rights reserved.
//
//

import Foundation
import CoreData


extension List {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<List> {
        return NSFetchRequest<List>(entityName: "List")
    }

    @NSManaged public var date: String
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var restaurants: NSSet

}

// MARK: Generated accessors for restaurants
extension List {

    @objc(addRestaurantsObject:)
    @NSManaged public func addToRestaurants(_ value: Restaurant)

    @objc(removeRestaurantsObject:)
    @NSManaged public func removeFromRestaurants(_ value: Restaurant)

    @objc(addRestaurants:)
    @NSManaged public func addToRestaurants(_ values: NSSet)

    @objc(removeRestaurants:)
    @NSManaged public func removeFromRestaurants(_ values: NSSet)

}

extension List : Identifiable {
  convenience init(id: String, date: String, name: String, context: NSManagedObjectContext) {
    let entity = NSEntityDescription.entity(forEntityName: "List", in: context)!
    self.init(entity: entity, insertInto: context)
    self.id = id
    self.name = name
    self.date = date
  }
}
