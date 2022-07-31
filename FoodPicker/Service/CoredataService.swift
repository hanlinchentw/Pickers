//
//  InternalService.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/2/23.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class CoredataConnect {
    enum CoreDataEntityType: String {
        case select
        case like
    
        var description: String {
            switch self {
            case .select: return selectedEntityName
            case .like: return likedEntityName
            }
        }
    }
    //MARK: - Properties
    private var context: NSManagedObjectContext!
    //MARK: - lifecycle
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    func deleteAll(entity: String){
        let request = NSFetchRequest<NSManagedObject>(entityName: entity)
        do{
            let results = try context.fetch(request)
            for object in results {
                context.delete(object)
                try context.save()
            }
        }catch{
            print("Debug: Failed to delete \(error.localizedDescription)")
        }
    }
}
//MARK: - Select and like CRUD
extension CoredataConnect {
    func saveRestaurant(toEntity type: CoreDataEntityType, restaurant: Restaurant) {
        if type == .select{
            let _ = self.transformRestaurantsIntoSelectedRestaraunts(restaurants: [restaurant])
        }else if type == .like{
            let _ = self.transformRestaurantsIntoLikedRestaraunts(restaurants: [restaurant])
        }
        do {
            try self.context.save()
        }catch {
            print("DEBUG: Failed to save data in SQL ... \(error.localizedDescription) ")
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
              let dict : [String : Any?] = [
                  "id": raw.id,
                  "name" : raw.name,
                  "rating" : raw.rating,
                  "price" : raw.price,
                  "imageUrl" : raw.imageUrl,
                  "reviewCount" : Int(raw.reviewCount),
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
    func deleteRestaurantIn(entityName: String, id: String){
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id == %@", id)
        do{
            let result = try context.fetch(request)
            for object in result{
                context.delete(object)
                try context.save()
            }
        }catch{
            print("DEBUG: Failed to delete data ... \(error.localizedDescription)")
        }
    }
    func checkIfRestaurantIsIn(entity name: String, id: String,
                               completion: @escaping(Bool)->Void){
        let request = NSFetchRequest<NSManagedObject>(entityName: name)
        request.returnsObjectsAsFaults = false
        let restaurantIDPredicate = NSPredicate(format: "id == %@", id)
        let andPredicate = NSCompoundPredicate(type: .and,
                                               subpredicates: [restaurantIDPredicate])
        request.predicate = andPredicate
        do{
            let object = try context.fetch(request)
            let isExisted = (object.count >= 1)
            completion(isExisted)
        }catch{
            print("Debug: Failed to read data in core data model ... \(error.localizedDescription)")
        }
    }
    
}
//MARK: - List CRUD
extension CoredataConnect {
    func saveList(list: List, success: @escaping (String?) -> Void,
                  failure: @escaping (Error) -> Void){
        guard let entity = NSEntityDescription.entity(forEntityName: listEntityName, in: self.context) else { return }
        var object = NSManagedObject(entity: entity, insertInto: self.context) as! ListEntity
        object.id = list.id  ?? UUID().uuidString
        object = self.wrapSavedList(savedList: object, list: list)
        do {
            try self.context.save()
            success(object.id)
        }catch {
            print("DEBUG: Failed to save data in SQL ... \(error.localizedDescription) ")
            failure(error)
        }
    }
    func fetchLists(completion: @escaping([List], Error?)->Void){
        var lists = [List]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: listEntityName)
        do{
            guard let results = try context.fetch(request) as? [ListEntity] else { completion([], nil)
                return
            }
            for object in results {
                guard let name = object.name,
                      let dateString = object.date,
                      let id = object.id,
                      let restaurantNSSet = object.restaurants else { continue }
                let restaurants = unzipNSSetIntoRestaurants(sets: restaurantNSSet)
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd hh:mm"
                guard let date = formatter.date(from: dateString) else { return }
                var list = List(name: name, restaurants: restaurants, date: date)
                list.id = id
                lists.append(list)
            }
            completion(lists, nil)
        }catch {
            completion([], error)
        }
    }
    func updateList(list: List){
        deleteList(list: list) {
            self.saveList(list: list) { _ in
            } failure: { _ in
            }
        } failure: { _ in
        }
    }
    func deleteList(list: List, success: @escaping () -> Void,
                    failure: @escaping (Error) -> Void) {
        let request = NSFetchRequest<NSManagedObject>(entityName: listEntityName)
        request.returnsObjectsAsFaults = false
        guard let id = list.id else { return }
        request.predicate = NSPredicate(format: "id == %@", id)
        do{
            let result = try context.fetch(request)
            for object in result {
                guard let object = object as? ListEntity else { return }
                self.deleteSavedRestaurants(belongTo: object)
                context.delete(object)
                try context.save()
                success()
            }
        }catch{
            print("Debug: Failed to delete stock \(error.localizedDescription)")
            failure(error)
        }
    }
    func deleteSavedRestaurants(belongTo savedList: ListEntity){
        let request = NSFetchRequest<NSManagedObject>(entityName: savedRestaurantName)
        request.returnsObjectsAsFaults = false
        guard let id = savedList.id else { return }
        request.predicate = NSPredicate(format: "belongList.id == %@", id)
        do{
            let result = try context.fetch(request) as! [SavedRestaurant]
            for object in result {
                context.delete(object)
                try context.save()
            }
        }catch{
            print("Debug: Failed to delete \(error.localizedDescription)")
        }
    }
}
//MARK: -  search history
extension CoredataConnect {
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
    
}
//MARK: - Helpers
extension CoredataConnect {
    private func wrapSavedList(savedList: ListEntity, list: List) -> ListEntity{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        let dateString = formatter.string(from: Date())
        savedList.name = list.name
        savedList.date = dateString
        let savedRestaurants = self.transformRestaurantsIntoSavedRestaraunts(savedList: savedList, restaurants: list.restaurants)
        for savedRestaurant in savedRestaurants {
            print(savedRestaurant)
            savedList.addToRestaurants(savedRestaurant)
        }
        return savedList
    }
    private func transformRestaurantsIntoSavedRestaraunts(savedList: ListEntity, restaurants: [Restaurant]) -> [SavedRestaurant] {
        var savedRestaurants = [SavedRestaurant]()
        for restaurant in restaurants {
            let object = SavedRestaurant(context: self.context)
            object.id = restaurant.restaurantID
            object.name = restaurant.name
            object.category = restaurant.categories
            object.imageUrl = restaurant.imageUrl
            object.latitude = restaurant.coordinates.latitude
            object.longitude = restaurant.coordinates.longitude
            object.price = restaurant.price
            object.rating = restaurant.rating
            object.reviewCount = Int16(restaurant.reviewCount)
            object.belongList = savedList
            savedRestaurants.append(object)
        }
        return savedRestaurants
    }
    private func transformRestaurantsIntoSelectedRestaraunts(restaurants: [Restaurant]) -> [SelectedRestaurant] {
        var selectedRestaurants = [SelectedRestaurant]()
        for restaurant in restaurants {
            guard let entity = NSEntityDescription.entity(forEntityName: selectedEntityName, in: self.context) else { return [] }
            let object = SelectedRestaurant(entity: entity, insertInto: self.context)
            object.id = restaurant.restaurantID
            object.name = restaurant.name
            object.category = restaurant.categories
            object.imageUrl = restaurant.imageUrl
            object.latitude = restaurant.coordinates.latitude
            object.longitude = restaurant.coordinates.longitude
            object.price = restaurant.price
            object.rating = restaurant.rating
            object.reviewCount = Int16(restaurant.reviewCount)
            selectedRestaurants.append(object)
        }
        return selectedRestaurants
    }
    func transformSelectedRestaurantIntoRestaraunt(selected: SelectedRestaurant) -> Restaurant{
        let coordinate = CLLocationCoordinate2D(latitude: selected.latitude, longitude: selected.longitude)
        let dict : [String : Any?] = [
            "id": selected.id,
            "name" : selected.name,
            "rating" : selected.rating,
            "price" : selected.price,
            "imageUrl" : selected.imageUrl,
            "reviewCount" : Int(selected.reviewCount),
            "category" : selected.category,
            "coordinate" : coordinate,
        ]
        let restaurant = Restaurant(business: nil, dictionary: dict)
        return restaurant
    }
    private func transformRestaurantsIntoLikedRestaraunts(restaurants: [Restaurant]) -> [LikedRestaurant] {
        var likedRestaurants = [LikedRestaurant]()
        for restaurant in restaurants {
            guard let entity = NSEntityDescription.entity(forEntityName: likedEntityName, in: self.context) else { return [] }
            let object = LikedRestaurant(entity: entity, insertInto: self.context)
            object.id = restaurant.restaurantID
            object.name = restaurant.name
            object.category = restaurant.categories
            object.imageUrl = restaurant.imageUrl
            object.latitude = restaurant.coordinates.latitude
            object.longitude = restaurant.coordinates.longitude
            object.price = restaurant.price
            object.rating = restaurant.rating
            object.reviewCount = Int16(restaurant.reviewCount)
            likedRestaurants.append(object)
        }
        return likedRestaurants
    }
    func unzipNSSetIntoRestaurants(sets: NSSet) -> [Restaurant] {
        print(sets)
        guard let sets = sets.allObjects as? [SavedRestaurant] else { return [] }
        var restaurants = [Restaurant]()
        for set in sets {
            let dictionary = ["id": set.id,
                              "name": set.name,
                              "imageUrl": set.imageUrl,
                              "rating": set.rating,
                              "reviewCount": Int(set.reviewCount),
                              "price": set.price,
                              "coordinate": CLLocationCoordinate2D(latitude: set.latitude, longitude: set.longitude),
                              "category": set.category] as [String : Any]
            var restaurant = Restaurant(dictionary: dictionary)
            restaurant.isSelected = true
            restaurants.append(restaurant)
        }
        return restaurants
    }
}
