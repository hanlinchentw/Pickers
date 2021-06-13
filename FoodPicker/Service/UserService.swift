//
//  LoginProvider.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/13.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase


//protocol LoginProvider {
//    func login(completion: (LoginResult) -> Void)
//}
enum LoginResult {
    case success(User)
    case failure(LoginError)
}

enum LoginError: Error {
    case noInternet
    case invalidEmailOrPassword
    case serverError
}
typealias DatabaseCompletion = ((Error?, DatabaseReference)->Void)

struct UserService{
    static var shared = UserService()
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping(LoginResult) -> Void){
        let count = password.count
        guard count >= 6, count <= 20 else {
            completion(.failure(.invalidEmailOrPassword) )
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                completion(.failure(.serverError))
            }else {
                guard let user = result?.user else {
                    completion(.failure(.serverError))
                    return 
                }
                completion(.success(user))
            }
        }
    }
    
    func checkIfUserIsExisted(withEmail email: String, completion: @escaping(Bool)->Void){
        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, err) in
            if let err = err { print("DEUBG: This email ...\(err.localizedDescription)")}
            guard let methods = methods else {  completion(false); return }
            completion(true)
        }
    }
    func createUser(withEmail email:String, password : String, completion: @escaping(DatabaseCompletion)){
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
