//
//  UIViewController_Extension.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/1.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit
import CoreData

fileprivate var aView: UIView?

extension UIViewController{
    func showSpinner(){
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.center = aView!.center
        activityIndicator.startAnimating()
        aView?.addSubview(activityIndicator)
        self.view.addSubview(aView!)
    }
    
    func removeSpinner(){
        aView?.removeFromSuperview()
        aView = nil
        
    }
    
    func updateSelectedRestaurantsInCoredata(context: NSManagedObjectContext ,restaurant: Restaurant){
        let connect = CoredataConnect(context: context)

        connect.checkIfRestaurantIsIn(entity: selectedEntityName, id: restaurant.restaurantID) { (isSelected) in
            if isSelected{
                connect.deleteRestaurantIn(entityName: selectedEntityName, id: restaurant.restaurantID)
            }else{
                connect.saveRestaurantInLocal(restaurant: restaurant, entityName: selectedEntityName,
                                              trueForSelectFalseForLike: true)
            }
        }
    }
    
    func checkIfRestaurantIsSelected(context: NSManagedObjectContext, restaurant: Restaurant, completion: @escaping(Bool)->Void){
        let connect = CoredataConnect(context: context)
        connect.checkIfRestaurantIsIn(entity: selectedEntityName, id: restaurant.restaurantID) { (isSelected) in
            completion(isSelected)
        }
    }
    
    func updateLikedRestaurantsInDataBase(context: NSManagedObjectContext, restaurant: Restaurant){
        RestaurantService.shared.updateLikedRestaurant(restaurant: restaurant, shouldLike: restaurant.isLiked)
        let connect = CoredataConnect(context: context)
        connect.checkIfRestaurantIsIn(entity: likedEntityName, id: restaurant.restaurantID) { (isLiked) in
            if isLiked{
                connect.deleteRestaurantIn(entityName: likedEntityName, id: restaurant.restaurantID)
            }else{
                connect.saveRestaurantInLocal(restaurant: restaurant, entityName: likedEntityName,
                                              trueForSelectFalseForLike: false)
            }
        }
    }
    
    func checkIfUserLiked(context: NSManagedObjectContext, uncheckedRestaurant: Restaurant, completion: @escaping(Bool)->Void){
        let connect = CoredataConnect(context: context)
        connect.checkIfRestaurantIsIn(entity: likedEntityName, id: uncheckedRestaurant.restaurantID) { (isLiked) in
            completion(isLiked)
        }
    }
    
    func fetchRestaurantsByOption(location: CLLocationCoordinate2D , option: recommendOption? = nil, limit: Int, offset: Int = 0 ,completion: @escaping(restaurantResponse)) {
        NetworkService.shared
            .fetchRestaurants(lat: location.latitude, lon: location.longitude, withOffset: offset, option: option,limit: limit)
            { restaurants, error in
                guard let res = restaurants, !res.isEmpty else {
                    print("DEBUG: Failed to get the restaurants ...")
                    completion(nil, error)
                    return
                }
                print("DEBUG: Loading data ...")
                completion(res,nil)
        }
    }
    
    func retry(_ times: Int, task: @escaping(@escaping () -> Void, @escaping (Error) -> Void) -> Void, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        task(success,
            { error in
                if times > 0 {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self.retry(times - 1, task: task, success: success, failure: failure)
                    }
                } else {
                    failure(URLRequestFailureResult(rawValue: 0)!)
                }
            })
    }
}
