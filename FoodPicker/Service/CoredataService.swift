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
    //MARK: - Properties
    private var context: NSManagedObjectContext!
    private var uid = Auth.auth().currentUser?.uid
    //MARK: - lifecycle
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    //MARK: -  Helpers
    func saveRestaurantInLocal(restaurant: Restaurant, entityName: String, trueForSelectFalseForLike: Bool){
        guard let uid = uid else { return }
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: self.context)
        if trueForSelectFalseForLike{
            let object = NSManagedObject(entity: entity!, insertInto: self.context) as! SelectedRestaurant
            object.id = restaurant.restaurantID
            object.name = restaurant.name
            object.rating = restaurant.rating
            object.reviewCount = Int16( restaurant.reviewCount)
            object.price = restaurant.price
            object.latitude = Double(restaurant.coordinates.latitude)
            object.longitude = Double(restaurant.coordinates.longitude)
            object.category = restaurant.categories
            object.imageUrl = restaurant.imageUrl
        }else{
            let object = NSManagedObject(entity: entity!, insertInto: self.context) as! LikedRestaurant
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
        }
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
            let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [restaurantIDPredicate])
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
    func deleteAllRestaurant(in entity: String){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        let _ = try? context.execute(delete)
    }
    
}
