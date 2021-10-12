//
//  CoredataOperation.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/10/7.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit
import CoreData

protocol CoredataOperation where Self: UIViewController {
    var context: NSManagedObjectContext { get }
    func updateSelectedRestaurantsInCoredata(context: NSManagedObjectContext ,restaurant: Restaurant)
    func checkIfRestaurantIsSelected(restaurant: Restaurant, completion: @escaping(Bool)->Void)
    func updateLikedRestaurantsInDataBase(context: NSManagedObjectContext, restaurant: Restaurant)
    func checkIfUserLiked(context: NSManagedObjectContext, uncheckedRestaurant: Restaurant, completion: @escaping(Bool)->Void)
    func restaurantsLikeStatusCheck(restaurants: [Restaurant], completion: @escaping([Restaurant])->Void)
}

extension CoredataOperation{
    func updateSelectedRestaurantsInCoredata(context: NSManagedObjectContext ,restaurant: Restaurant){
        let connect = CoredataConnect(context: context)
        connect.checkIfRestaurantIsIn(entity: selectedEntityName,
                                      id: restaurant.restaurantID) { (isSelected) in
            if isSelected{
                connect.deleteRestaurantIn(entityName: selectedEntityName, id: restaurant.restaurantID)
            }else{
                connect.saveRestaurant(toEntity: .select, restaurant: restaurant)
            }
        }
    }
    func checkIfRestaurantIsSelected(restaurant: Restaurant, completion: @escaping(Bool)->Void){
        let connect = CoredataConnect(context: context)
        connect.checkIfRestaurantIsIn(entity: selectedEntityName,
                                      id: restaurant.restaurantID) { (isSelected) in
            print("DEBUG: Is selected \(isSelected)")
            completion(isSelected)
        }
    }
    func checkIfUserLiked(context: NSManagedObjectContext, uncheckedRestaurant: Restaurant, completion: @escaping(Bool)->Void){
        let connect = CoredataConnect(context: context)
        connect.checkIfRestaurantIsIn(entity: likedEntityName, id: uncheckedRestaurant.restaurantID) { (isLiked) in
            completion(isLiked)
        }
    }
    func updateLikedRestaurantsInDataBase(context: NSManagedObjectContext, restaurant: Restaurant){
        let connect = CoredataConnect(context: context)
        print(restaurant)
        connect.checkIfRestaurantIsIn(entity: likedEntityName, id: restaurant.restaurantID) { (isLiked) in
            if isLiked{
                connect.deleteRestaurantIn(entityName: likedEntityName, id: restaurant.restaurantID)
            }else{
                print("Saved")
                connect.saveRestaurant(toEntity: .like, restaurant: restaurant)
            }
        }
    }
    

    func restaurantsLikeStatusCheck(restaurants: [Restaurant], completion: @escaping([Restaurant])->Void) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var uncheckedRestaurants = restaurants
        for (index, item) in uncheckedRestaurants.enumerated(){
            self.checkIfUserLiked(context: context, uncheckedRestaurant: item) { (isLiked) in
                uncheckedRestaurants[index].isLiked = isLiked
                completion(uncheckedRestaurants)
            }
        }
    }
    func deleteLikedRestaurant(_ restaurant: Restaurant){
        let coreConnect = CoredataConnect(context: context)
        coreConnect.deleteRestaurantIn(entityName: likedEntityName, id: restaurant.restaurantID)
    }
    func deselectAll(){
        let coreConnect = CoredataConnect(context: context)
        coreConnect.deleteAll(entity: selectedEntityName)
    }
    func transfromSelectedRestaurantIntoRestaurant(selectedRestaurant: SelectedRestaurant) -> Restaurant{
        let coreConnect = CoredataConnect(context: context)
        return coreConnect.transformSelectedRestaurantIntoRestaraunt(selected: selectedRestaurant)
         
    }
}
