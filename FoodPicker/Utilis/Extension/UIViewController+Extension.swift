//
//  UIViewController_Extension.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/1.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit
import CoreData
import Combine
import CoreLocation

extension UIViewController{
    func fetchRestaurantsByOption(location: CLLocationCoordinate2D ,
                                  option: recommendOption? = nil,
                                  limit: Int = 50, offset: Int = 0 ,completion: @escaping(restaurantResponse)) {
        NetworkService.shared.fetchRestaurants(lat: location.latitude, lon: location.longitude,
                                               withOffset: offset, option: option, limit: limit)
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
    func presentPopupViewWithButtonAndProvidePublisher(title: String, subtitle: String,
                                             buttonTitle:  String) -> UIControlPublisher<UIButton>{
        let popup = PopupView(title: title, titleFont: 24, subtitle: subtitle, subtitleFont: 16,
                              withButton: true, buttonTitle: buttonTitle)
        guard let window = UIApplication.shared.windows.first else { fatalError("DEBUG: Keywindow isn't existed.") }
        window.addSubview(popup)
        return popup.actionButton.publisher(for: .touchUpInside)
    }
    
    func presentPopupViewWithoutButton(title: String, subtitle: String) {
        let popup = PopupView(title: title, titleFont: 24, subtitle: subtitle, subtitleFont: 16, withButton: false)
        guard let window = UIApplication.shared.windows.first else { fatalError("DEBUG: Keywindow isn't existed.") }
        window.addSubview(popup)
    }
    
    func retry(_ times: Int, task: @escaping(@escaping () -> Void, @escaping (Error) -> Void) -> Void,
               success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        task(success, { error in
                if times > 0 {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        self.retry(times - 1, task: task, success: success, failure: failure)
                    }
                } else {
                    failure(URLRequestFailureResult(rawValue: 0)!)
                }
            })
    }
}
