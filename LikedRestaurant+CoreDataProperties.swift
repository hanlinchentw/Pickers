//
//  LikedRestaurant+CoreDataProperties.swift
//  
//
//  Created by 陳翰霖 on 2021/10/10.
//
//

import Foundation
import CoreData


extension LikedRestaurant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikedRestaurant> {
        return NSFetchRequest<LikedRestaurant>(entityName: "LikedRestaurant")
    }

    @NSManaged public var category: String?
    @NSManaged public var id: String?
    @NSManaged public var imageUrl: URL?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var rating: Double
    @NSManaged public var reviewCount: Int16
    @NSManaged public var uid: String?

}
