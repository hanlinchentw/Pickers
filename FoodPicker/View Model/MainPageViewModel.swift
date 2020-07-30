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
    
    private var options = [FilterOptions]()
    
    var mutableOption : FilterOptions? {
        didSet{
            guard let option = mutableOption else { return }
            if !options.contains(option){
                self.options.append(option)
                fetchRestaurants(option: option)
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
            guard let option = restaurants[0].filterOption else { return }
            let source = FoodCardDataSoruce(restaurants: restaurants, option: option)
            self.dataSource.append(source)

            return
        }
    }
    
    public var dataSource = [FoodCardDataSoruce]()

    public func fetchRestaurants(withCategory category : String = "food", option: FilterOptions){
        guard let location = LocationHandler.shared.currentLocation else { return }
        let sortBy = option.sortby
        
        service.fetchRestaurant(lat: location.latitude, lon: location.longitude,
                                              withOffset: 0,
                                              category: category,
                                              sortBy: sortBy,
                                              option: option)
        { [weak self] (res) in
            self?.restaurants = res
        }
    }
    
    var numOfSection : Int {
        return dataSource.count
    }
    
    public func numOfCell(index : Int) -> Int {
        return dataSource[index].restaurants.count
    }
    
    public func optionForCell(index: Int) -> FilterOptions {
        return dataSource[index].option
    }
    public func restaurantsForCell(index : Int) -> [Restaurant] {
        return dataSource[index].restaurants
    }
}
