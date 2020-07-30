//
//  FirebaseService.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/17.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import Firebase

struct UserService{
    static var shared = UserService()
    
    func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func checkIfUserIsExisted(withEmail email: String, completion: @escaping(Bool)->Void){
        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, err) in
            if let err = err { print("DEUBG: This email ...\(err.localizedDescription)")}
//            guard let methods = methods else {  completion(false); return }
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
    
    func fetchUser(completion:@escaping(User)->Void){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        REF_USER.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            let uid = snapshot.key
//            guard let dictionary = snapshot.value as? [String:Any] else { return }
            let user = User(uid: uid)
            completion(user)
        }
    }
}

struct RestaurantService {
    static let shared = RestaurantService()
    func updateLikedRestaurant(uid:String, restaurantID:String){
        REF_USER_LIKE.child(uid).updateChildValues([restaurantID:1]) { (err, ref) in
            if let err = err {
                print("DEBUG: Failed to update liked restaurant..\(err.localizedDescription)")
            }
            
        }
    }
}
