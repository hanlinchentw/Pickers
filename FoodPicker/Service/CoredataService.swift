//
//  InternalService.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/2/23.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import Foundation
import CoreData

class CoredataConnect{
    //MARK: - Properties
    private var context: NSManagedObjectContext!
    //MARK: - lifecycle
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    //MARK: -  Helpers
    func saveData(entityName: String, NSManagedObject: NSManagedObject){
        do{
            try context.save()
        }catch{
            print("DEBUG: Failed to save data \(error.localizedDescription)")
        }
    }
    func saveRestaurantInLocal(restaurant: Restaurant, entityName: String, trueForSelectFalseForLike: Bool){
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
        do{
            try context.save()
        }catch{
            print("DEBUG: Failed to save data \(error.localizedDescription)")
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
        let request = NSFetchRequest<NSManagedObject>(entityName: name)
        request.returnsObjectsAsFaults = false
        if let id = id{
            request.predicate = NSPredicate(format: "id == %@", id)
        }
        do{
            let object = try context.fetch(request)
            let isSelected = (object.count >= 1)
            completion(isSelected)
        }catch{
            print("Debug: Failed to read data in core data model ... \(error.localizedDescription)")
        }
    }
    func fetchLikedRestaurant(completion: @escaping(([Restaurant]) -> Void)){
        var restaurants = [Restaurant]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: likedEntityName)
        
        do{
            let object = try context.fetch(request) as! [LikedRestaurant]
            print("DEBUG: Fetch from coredata \(object)")
            for raw in object{
                let coordinate = CLLocationCoordinate2D(latitude: raw.latitude, longitude: raw.longitude)
                let dict : [String:Any] = [
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
        }catch{
            print("Debug: Failed to read data in core data model ... \(error.localizedDescription)")
        }
        completion(restaurants)
    }
    func deselectAllRestaurants(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: selectedEntityName)
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        let _ = try? context.execute(delete)
    }
}
