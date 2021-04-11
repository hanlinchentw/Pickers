//
//  SelectedRestaurant+CoreDataProperties.swift
//  
//
//  Created by 陳翰霖 on 2021/2/24.
//
//

import Foundation
import CoreData


extension SelectedRestaurant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SelectedRestaurant> {
        return NSFetchRequest<SelectedRestaurant>(entityName: "SelectedRestaurant")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?

}
