//
//  User+CoreDataProperties.swift
//  
//
//  Created by 陳翰霖 on 2021/6/1.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: String?
    @NSManaged public var email: String?
    @NSManaged public var userLiked: NSOrderedSet?
    @NSManaged public var userSelected: NSSet?

}

// MARK: Generated accessors for userLiked
extension User {

    @objc(insertObject:inUserLikedAtIndex:)
    @NSManaged public func insertIntoUserLiked(_ value: LikedRestaurant, at idx: Int)

    @objc(removeObjectFromUserLikedAtIndex:)
    @NSManaged public func removeFromUserLiked(at idx: Int)

    @objc(insertUserLiked:atIndexes:)
    @NSManaged public func insertIntoUserLiked(_ values: [LikedRestaurant], at indexes: NSIndexSet)

    @objc(removeUserLikedAtIndexes:)
    @NSManaged public func removeFromUserLiked(at indexes: NSIndexSet)

    @objc(replaceObjectInUserLikedAtIndex:withObject:)
    @NSManaged public func replaceUserLiked(at idx: Int, with value: LikedRestaurant)

    @objc(replaceUserLikedAtIndexes:withUserLiked:)
    @NSManaged public func replaceUserLiked(at indexes: NSIndexSet, with values: [LikedRestaurant])

    @objc(addUserLikedObject:)
    @NSManaged public func addToUserLiked(_ value: LikedRestaurant)

    @objc(removeUserLikedObject:)
    @NSManaged public func removeFromUserLiked(_ value: LikedRestaurant)

    @objc(addUserLiked:)
    @NSManaged public func addToUserLiked(_ values: NSOrderedSet)

    @objc(removeUserLiked:)
    @NSManaged public func removeFromUserLiked(_ values: NSOrderedSet)

}

// MARK: Generated accessors for userSelected
extension User {

    @objc(addUserSelectedObject:)
    @NSManaged public func addToUserSelected(_ value: SelectedRestaurant)

    @objc(removeUserSelectedObject:)
    @NSManaged public func removeFromUserSelected(_ value: SelectedRestaurant)

    @objc(addUserSelected:)
    @NSManaged public func addToUserSelected(_ values: NSSet)

    @objc(removeUserSelected:)
    @NSManaged public func removeFromUserSelected(_ values: NSSet)

}
