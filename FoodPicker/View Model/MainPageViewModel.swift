//
//  MainPageViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/24.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import Foundation

class MainPageViewModel {
    private let service = NetworkService()
    
    private var options = [SortOption]()
    
    var mutableOption : SortOption? {
        didSet{
            guard let option = mutableOption else { return }
            if !options.contains(option){
                self.options.append(option)
              
                return
            }else {
                self.options.remove(at: self.options.firstIndex(of: option)!)
                for (index, item) in dataSource.enumerated() {
                    if item.option == option{
                        self.dataSource.remove(at: index)
                        return
                    }
                }
            }
        }
    }
    private var restaurants : [Restaurant]? {
        didSet {
            guard let restaurants = restaurants else {return }
            guard let option = restaurants[0].sortOption else { return }
            let source = SortedDataSource(option: option, restaurants: restaurants)
            self.dataSource.append(source)

            return
        }
    }
    
    public var dataSource = [SortedDataSource]()

    
    
    var numOfSection : Int {
        return dataSource.count
    }
    
    public func numOfCell(index : Int) -> Int {
        return dataSource[index].restaurants.count
    }
    
    public func optionForCell(index: Int) -> SortOption {
        return dataSource[index].option
    }
    public func restaurantsForCell(index : Int) -> [Restaurant] {
        return dataSource[index].restaurants
    }
}
