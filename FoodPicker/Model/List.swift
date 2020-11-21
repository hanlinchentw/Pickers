//
//  List.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/11/17.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import Foundation

struct List {
    var id: String?
    var name: String
    var restaurantsID: [String]
    var restaurants = [Restaurant]()
    let timeStamp: Double
    
    var count: Int
    var isEdited : Bool = false
    init(name:String, restaurantsID: [String], timestamp: Double) {
        self.name = name
        self.restaurantsID = restaurantsID
        self.timeStamp = timestamp
        self.count = restaurantsID.count
    }
    
}


