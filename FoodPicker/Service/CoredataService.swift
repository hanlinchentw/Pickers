//
//  InternalService.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/2/23.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import Foundation
import CoreData
import FirebaseAuth

class CoredataConnect{
    enum CoreDataEntityType: String {
        case select
        case like
        
        var entityClass: NSManagedObject.Type {
            switch self {
            case .select: return SelectedRestaurant.self
            case .like: return LikedRestaurant.self
            }
        }
        
        var description: String {
            switch self {
            case .select: return selectedEntityName
            case .like: return likedEntityName
            }
        }
    }
    //MARK: - Properties
    private var context: NSManagedObjectContext!
    private var uid = Auth.auth().currentUser?.uid
    //MARK: - lifecycle
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    //MARK: -  Helpers
    func saveSelectedRestaurant(restaurant: Restaurant) {
        guard let entity = NSEntityDescription.entity(forEntityName: selectedEntityName, in: self.context) else { return }
        guard let object = NSManagedObject(entity: entity, insertInto: self.context) as? SelectedRestaurant else { return }
        object.id = restaurant.restaurantID
        object.name = restaurant.name
        object.rating = restaurant.rating
        object.reviewCount = Int16( restaurant.reviewCount)
        object.price = restaurant.price
        object.latitude = Double(restaurant.coordinates.latitude)
        object.longitude = Double(restaurant.coordinates.longitude)
        object.category = restaurant.categories
        object.imageUrl = restaurant.imageUrl
        do {
            try self.context.save()
        }catch {
            print("DEBUG: Failed to save data in SQL ... \(error.localizedDescription) ")
        }
    }
    func saveLikedRestaurant(restaurant: Restaurant) {
        guard let uid = uid else { return }
        guard let entity = NSEntityDescription.entity(forEntityName: likedEntityName, in: self.context) else { return }
        guard let object = NSManagedObject(entity: entity, insertInto: self.context) as? LikedRestaurant else { return }
        object.uid = uid
        object.id = restaurant.restaurantID
        object.name = restaurant.name
        object.rating = restaurant.rating
        object.reviewCount = Int16( restaurant.reviewCount)
        object.price = restaurant.price
        object.latitude = Double(restaurant.coordinates.latitude)
        object.longitude = Double(restaurant.coordinates.longitude)
        object.category = restaurant.categories
        object.imageUrl = restaurant.imageUrl
        do {
            try self.context.save()
        }catch {
            print("DEBUG: Failed to save data in SQL ... \(error.localizedDescription) ")
        }
    }
    func saveSearchHistoryInEntity(term: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: searchHistoryEntityName, in: self.context) else { return }
        guard let object = NSManagedObject(entity: entity, insertInto: self.context) as? SearchHistory else { return }
        object.term = term
        object.timestamp = Date().timeIntervalSinceReferenceDate
        do {
            try self.context.save()
        }catch {
            print("DEBUG: Failed to save data in SQL ... \(error.localizedDescription) ")
        }
    }
    func deleteRestaurantIn(entityName: String, id: String){
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id == %@", id)
        do{
            let result = try context.fetch(request)
            for object in result{
                print("DEBUG: Delete object)")
                context.delete(object)
                print("DEBUG: Delete operation is done.")
                try context.save()
            }
        }catch{
            print("DEBUG: Failed to delete data ... \(error.localizedDescription)")
        }
    }
    func checkIfRestaurantIsIn(entity name: String, id: String?, completion: @escaping(Bool)->Void){
        guard let uid = uid else { return }
        let request = NSFetchRequest<NSManagedObject>(entityName: name)
        request.returnsObjectsAsFaults = false
        if let id = id{
            let userIDPredicate = NSPredicate(format: "uid == %@", uid)
            let restaurantIDPredicate = NSPredicate(format: "id == %@", id)
            let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [restaurantIDPredicate,userIDPredicate])
            request.predicate = restaurantIDPredicate
            if name == likedEntityName {
                request.predicate = andPredicate
            }
        }
        do{
            let object = try context.fetch(request)
            let isSelected = (object.count >= 1)
            completion(isSelected)
        }catch{
            print("Debug: Failed to read data in core data model ... \(error.localizedDescription)")
        }
    }
    func fetchLikedRestaurant(uid: String, completion: @escaping(([Restaurant]) -> Void)){
        var restaurants = [Restaurant]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: likedEntityName)
        do{
            let object = try context.fetch(request) as! [LikedRestaurant]
            print("DEBUG: Fetch from coredata \(object)")
            for raw in object{
                if raw.uid == uid {
                    let coordinate = CLLocationCoordinate2D(latitude: raw.latitude, longitude: raw.longitude)
                    let dict : [String : Any?] = [
                        "id": raw.id,
                        "name" : raw.name,
                        "rating" : raw.rating,
                        "price" : raw.price,
                        "imageUrl" : raw.imageUrl,
                        "reviewCount" : raw.reviewCount,
                        "category" : raw.category,
                        "coordinate" : coordinate,
                    ]
                    let restaurant = Restaurant(business: nil, dictionary: dict)
                    restaurants.append(restaurant)
                }
            }
        }catch{
            print("Debug: Failed to read data in core data model ... \(error.localizedDescription)")
        }
        completion(restaurants)
    }
    func fetchSearchHistory(completion: @escaping(([String]) -> Void)){
        var terms = [String]()
        let request : NSFetchRequest<SearchHistory> = SearchHistory.fetchRequest()
        request.fetchLimit = 3
        let sort = NSSortDescriptor(key: "timestamp", ascending: false)
        request.sortDescriptors = [sort]
        do{
            let object = try context.fetch(request)
            for data in object{
                guard let term = data.term else { return }
                terms.append(term)
            }
        }catch{
            print("Debug: Failed to read data in core data model ... \(error.localizedDescription)")
        }
        completion(terms)
    }
    func deleteAllRestaurant(in entity: String){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        let _ = try? context.execute(delete)
    }
    
}
