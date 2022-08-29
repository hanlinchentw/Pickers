//
//  SearchHistory+CoreDataProperties.swift
//  
//
//  Created by 陳翰霖 on 2022/8/28.
//
//  This file was automatically generated and should not be edited.
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

extension SearchHistory : Identifiable {

}
