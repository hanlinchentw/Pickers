//
//  FirebaseService.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/17.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import Firebase

struct RestaurantService {
    static let shared = RestaurantService()

    func checkIfUserLikeRestaurant(restaurantID: String, completion: @escaping(Bool)->Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_USER_LIKE.child(uid).child(restaurantID).observe(.value) { (snapshot) in
            completion(snapshot.exists())
        }
    }
    
    func updateLikedRestaurant(restaurant:Restaurant, shouldLike: Bool){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let restaurantID = restaurant.restaurantID
        let lat = restaurant.coordinates.latitude
        let lon = restaurant.coordinates.longitude
        let name = restaurant.name
        print("DEBUG: Update liked restaurant to firestore")
        if !shouldLike {
            REF_USER_LIKE.child(uid).child(restaurantID).removeValue()
            REF_RESTAURANT_LIKE.child(restaurantID).child(uid).removeValue()
        }else {
            let values = ["Name": name , "Latitude":lat,  "Longitude":lon] as [String : Any]
            REF_USER_LIKE.child(uid).child(restaurantID).updateChildValues(values)
            REF_RESTAURANT_LIKE.child(restaurantID).updateChildValues([uid:1])
        }
    }
    func fetchLikedRestaurants(completion: @escaping(([Restaurant])->Void)){
        var restaurants = [Restaurant]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print("DEBUG: UID: \(uid)")
        
        REF_USER_LIKE.child(uid).observe(.childAdded) { (snapshot) in
            NetworkService.shared.fetchDetail(id: snapshot.key) { (detail, error) in
                print("DEBUG: Successfully fetch liked restaurants.")
                let restaurant = Restaurant(business: nil, detail: detail)
                restaurants.append(restaurant)
                completion(restaurants)
            }
        }
    }
    func addHistoricalRecordbyTerm(term:String){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let timestamp = String(Int(Date().timeIntervalSince1970))
        REF_USER_SEARCH.child(uid).updateChildValues([timestamp:term]) { (err, ref) in
            if let error = err{
                print("DEBUG: Failed to update historical records ... \(error)")
            }
            self.updateSearchTerm(term: term)
        }
    }
    
    func updateSearchTerm(term: String){
        REF_SEARCH.observeSingleEvent(of: .value) { (snapshot) in
            if !snapshot.exists(){
                REF_SEARCH.child(term).updateChildValues(["num_of_searches": 1])
            }
        }
        REF_SEARCH.child(term).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            if let value = dictionary["num_of_searches"] as? Int {
                print("DEBUG:Database has this child ... ")
                REF_SEARCH.child(term).updateChildValues(["num_of_searches": value+1])
            }else{
                print("DEBUG:Database doesn't have this child ... ")
                REF_SEARCH.child(term).updateChildValues(["num_of_searches": 1])
            }
        }
    }
    func fetchHistoricalRecord(completion: @escaping(([String], Error?)->Void)){
        var historicalRecord = [String]()
        if !NetworkMonitor.shared.isConnected { completion([],  URLRequestFailureResult.noInternet) }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_USER_SEARCH.child(uid).observe(.childAdded) { (snapshot) in
            
            guard let record = snapshot.value as? String else { return }
            historicalRecord.insert(record, at: 0)
            historicalRecord = Array(historicalRecord.prefix(3))
            completion(historicalRecord, nil)
        }
    }
    
    func fetchTopSearches(completion: @escaping(([String], Error?)->Void)){
        if !NetworkMonitor.shared.isConnected { completion([],  URLRequestFailureResult.noInternet) }
        REF_SEARCH.queryOrderedByValue().observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
        }
    }
    func fetchRestaurantNumOfLike(restaurantID:String, completion: @escaping((Int)->Void)){
        var count = 0
        REF_RESTAURANT_LIKE.child(restaurantID).observeSingleEvent(of: .value) { (snapshot) in
            count = Int(snapshot.childrenCount)
            completion(count)
        }
    }
    
    func saveList(list: List) -> String?{
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        
        let name = list.name
        let timestamp = list.timeStamp
        let resID = list.restaurantsID
        let value = ["Name": name,"Timestamp": timestamp, "RestaurantsID": resID] as [String : Any]
        
        let autoID = REF_USER_LIST.child(uid).childByAutoId()
        autoID.updateChildValues(value)
        return autoID.key
    }
    func fetchSavedLists(completion: @escaping([List])->Void){
        var lists = [List]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_USER_LIST.child(uid).observe(.childAdded) { (snapshot) in
            let listID = snapshot.key
            guard let dict = snapshot.value as? [String : Any] else { return }
            guard let name = dict["Name"] as? String else { return }
            guard let resID = dict["RestaurantsID"] as? [String] else { return }
            guard let timestamp = dict["Timestamp"] as? Double else { return }
            var list = List(name: name, restaurantsID: resID, timestamp: timestamp)
            list.id = listID
            lists.append(list)
            completion(lists)
        }
    }
    func updateListAfterEditing(listID: String, completion: @escaping(List?)->Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_USER_LIST.child(uid).child(listID).observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists(){
                completion(nil)
            }else{
                let listID = snapshot.key
                guard let dict = snapshot.value as? [String : Any] else { return }
                guard let name = dict["Name"] as? String else { return }
                guard let resID = dict["RestaurantsID"] as? [String] else { return }
                guard let timestamp = dict["Timestamp"] as? Double else { return }
                var list = List(name: name, restaurantsID: resID, timestamp: timestamp)
                list.id = listID
                list.isEdited = true
                completion(list)
            }
        })
    }
    func updateSavedList(list:List, compltion:(()->Void)? = nil){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let listID = list.id else { return }
        let name = list.name
        let timestamp = list.timeStamp
        let resID = list.restaurantsID

        REF_USER_LIST.child(uid).child(listID).child("RestaurantsID")
            .observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() || list.restaurantsID.isEmpty {
                REF_USER_LIST.child(uid).child(listID).removeValue()
            }else{
                let value = ["Name": name,"Timestamp": timestamp, "RestaurantsID": resID] as [String : Any]
                REF_USER_LIST.child(uid).child(listID).updateChildValues(value)
            }
            guard let completion = compltion else { return }
            completion()
        })
    }
    func deleteList(listID:String){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_USER_LIST.child(uid).child(listID).removeValue()
    }
}
