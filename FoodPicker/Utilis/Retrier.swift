//
//  Retrier.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/2.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit


struct Retrier<T> {
    let times: UInt
    let task: (@escaping (T) -> Void, @escaping (Error) -> Void) -> Void
    
    func callAsFunction(success: @escaping (T) -> Void, failure: @escaping (Error) -> Void) {
        let failureWrapper: (Error) -> Void = { error in
            // do we have retries left? if yes, call retry again
            // if not, report error
            if times > 0 {
                Retrier(times: times - 1, task: task)(success: success, failure: failure)
            } else {
                failure(error)
            }
        }
        task(success, failureWrapper)
    }
    
    func callAsFunction(success: @escaping () -> Void, failure: @escaping (Error) -> Void) where T == Void {
        callAsFunction(success: { _ in }, failure: failure)
    }
}
