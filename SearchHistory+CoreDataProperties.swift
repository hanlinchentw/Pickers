//
//  SearchHistory+CoreDataProperties.swift
//  
//
//  Created by 陳翰霖 on 2021/10/10.
//
//

import Foundation
import CoreData


extension SearchHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchHistory> {
        return NSFetchRequest<SearchHistory>(entityName: "SearchHistory")
    }

    @NSManaged public var term: String?
    @NSManaged public var timestamp: Double

}
