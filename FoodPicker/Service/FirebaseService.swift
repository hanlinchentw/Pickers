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
        REF_USER_LIKE.child(uid).child(restaurantID).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.exists())
        }
    }
    
    func updateLikedRestaurant(restaurant:Restaurant, completion: @escaping(DatabaseCompletion)){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let restaurantID = restaurant.restaurantID
        let lat = restaurant.coordinates.latitude
        let lon = restaurant.coordinates.longitude
        let name = restaurant.name

        if restaurant.isLiked {
            REF_USER_LIKE.child(uid).child(restaurantID).removeValue()
        }else {
            let values = ["Name": name , "Latitude":lat,  "Longitude":lon] as [String : Any]
            REF_USER_LIKE.child(uid).child(restaurantID).updateChildValues(values,
                                   withCompletionBlock: completion)
        }
    }
    func fetchLikedRestaurants(completion: @escaping(([Restaurant])->Void)){
        var restaurants = [Restaurant]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_USER_LIKE.child(uid).observe(.childAdded) { (snapshot) in
            NetworkService.shared.fetchDetail(id: snapshot.key) { (detail) in
                let restaurant = Restaurant(detail: detail, business: nil)
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
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                if rest.key == term{
                    guard let num = rest.value as? Int else { return }
                    REF_SEARCH.updateChildValues([term:num+1])
                    return
                }else{
                    REF_SEARCH.updateChildValues([term:1])
                }
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
}
