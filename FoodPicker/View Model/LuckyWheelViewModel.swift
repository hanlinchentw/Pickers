//
//  LuckyWheelViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/15.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import Foundation
import iOSLuckyWheel

struct LuckyWheelViewModel  {
    var restaurants : [Restaurant]
    
    var itemForSection : [WheelItem] {
        var items1 = [WheelItem]()
        var items2 = [WheelItem]()
        if restaurants.count != 0 {
            if restaurants.count % 2 == 0{
                for (index, item) in restaurants.enumerated(){
                    let itemColor : UIColor = index%2 != 0 ? .white : .pale
                    let wheelItem1 = WheelItem(title: item.name, titleColor: .black, itemColor: itemColor)
                    items1.append(wheelItem1)
                    items2 = items1
                }
            }else{
                for (index, item) in self.restaurants.enumerated(){
                    let itemColor : UIColor = index%2 != 0 ? .white : .pale
                    let oppsiteColor : UIColor = itemColor == .white ? .pale : .white
                    let wheelItem1 = WheelItem(title: item.name, titleColor: .black, itemColor: itemColor)
                    let wheelItem2 = WheelItem(title: item.name, titleColor: .black, itemColor: oppsiteColor)
                    items1.append(wheelItem1)
                    items2.append(wheelItem2)
                }
            }
             return items1 + items2
        }
        return [WheelItem(title: "", titleColor: .black, itemColor: .pale)]
    }
    init(restaurants: [Restaurant]) {
        self.restaurants = restaurants
    }
}
