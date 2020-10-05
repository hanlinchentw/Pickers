//
//  LikedRestaurant+CoreDataProperties.swift
//  
//
//  Created by 陳翰霖 on 2020/8/8.
//
//

import Foundation
import CoreData


extension LikedRestaurant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikedRestaurant> {
        return NSFetchRequest<LikedRestaurant>(entityName: "LikedRestaurant")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var type: String?
    @NSManaged public var rating: Double
    @NSManaged public var reviewCount: Int64
    @NSManaged public var imageUrl: URL?

}
