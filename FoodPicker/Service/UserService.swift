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
    case incorrectPassword
    case serverError
}
enum RegisterResult {
    case success(User)
    case failure(RegisterError)
}
enum RegisterError: Error {
    case noInternet
    case invaildPassword
    case serverError
}


struct UserService{
    static var shared = UserService()
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping(LoginResult) -> Void){
        if !NetworkMonitor.shared.isConnected {completion(.failure(.noInternet))}
        else{
            let count = password.count
            guard count >= 6, count <= 20 else {
                completion(.failure(.incorrectPassword))
                return
            }
            
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if error != nil {
                    completion(.failure(.incorrectPassword))
                }else {
                    guard let user = result?.user else {
                        completion(.failure(.serverError))
                        return
                    }
                    completion(.success(user))
                }
            }
        }
    }
    
    func checkIfUserIsExisted(withEmail email: String, completion: @escaping(Bool?, LoginError?)->Void){
        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, err) in
            if !NetworkMonitor.shared.isConnected {completion(nil, LoginError.noInternet)}
            if let _ = err { completion(nil, LoginError.serverError)}
            guard let _ = methods else {  completion(false, nil); return }
            completion(true, nil)
        }
    }
    func createUser(withEmail email:String, password : String, completion: @escaping(RegisterResult) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if !NetworkMonitor.shared.isConnected {completion(.failure(.noInternet))}
            if let err = err {
                completion(.failure(.invaildPassword))
                return
            }
            guard let user = result?.user else {
                completion(.failure(.serverError))
                return
            }
            completion(.success(user))
        }
    }
}
