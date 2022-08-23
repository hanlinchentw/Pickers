//
//  Validators.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/13.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import Foundation

struct Validator<T> {
    let validate: (T)-> Bool
}

struct Validators {
    static var nonEmpty: Validator<String> {
        return Validator<String> { text in
            return !text.isEmpty
        }
    }
    static var email : Validator<String> {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,10}"
        let emailRegEx2 = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]+\\.[A-Za-z]{1,10}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let emailPred2 = NSPredicate(format:"SELF MATCHES %@", emailRegEx2)
        return Validator<String> { text in
            return emailPred.evaluate(with: text) || emailPred2.evaluate(with: text)
        }
    }
    static var password : Validator<String> {
        let passwordRegEx = "[A-Z0-9a-z]{6,20}"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return Validator<String> { text in
            return passwordPred.evaluate(with: text)
        }
        
    }
}
