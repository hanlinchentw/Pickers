//
//  FirebaseService.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/17.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import Firebase

typealias DatabaseCompletion = ((Error?, DatabaseReference)->Void)

struct UserService{
    static var shared = UserService()
    
    func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func checkIfUserIsExisted(withEmail email: String, completion: @escaping(Bool)->Void){
        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, err) in
            if let err = err { print("DEUBG: This email ...\(err.localizedDescription)")}
            guard let methods = methods else {  completion(false); return }
            completion(true)
        }
    }
    
    func createUser(withEmail email:String, password : String, completion: @escaping (Error?,DatabaseReference)-> Void){
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if let err = err {
                print("Failed to create User...\(err.localizedDescription)")
                return
            }
            
            guard let uid = result?.user.uid else { return }
            let values = ["email": email
            ]
            REF_USER.child(uid).updateChildValues(values, withCompletionBlock: completion)
        }
    }
}

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
        REF_USER_LIKE.child(uid).observe(.childAdded) { (snapshot) in
            NetworkService.shared.fetchDetail(id: snapshot.key) { (detail) in
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
    func fetchHistoricalRecord(completion: @escaping(([String])->Void)){
        var historicalRecord = [String]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_USER_SEARCH.child(uid).observe(.childAdded) { (snapshot) in
            guard let record = snapshot.value as? String else { return }
            historicalRecord.insert(record, at: 0)
            historicalRecord = Array(historicalRecord.prefix(3))
            completion(historicalRecord)
        }
    }
    
    func fetchTopSearches(completion: @escaping(([String])->Void)){
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
}
