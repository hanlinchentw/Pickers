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
}
