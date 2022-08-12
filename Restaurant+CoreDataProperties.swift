//
//  Restaurant+CoreDataProperties.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/12.
//  Copyright © 2022 陳翰霖. All rights reserved.
//
//

import Foundation
import CoreData


extension Restaurant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
    }

    @NSManaged public var businessCategory: String
    @NSManaged public var id: String
    @NSManaged public var imageUrl: URL?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String
    @NSManaged public var price: String
    @NSManaged public var rating: Double
    @NSManaged public var reviewCount: Int32

}

extension Restaurant : Identifiable {

}
