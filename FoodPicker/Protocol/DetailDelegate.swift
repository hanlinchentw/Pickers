//
//  DetailDelegate.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/10/6.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import Foundation
import CoreLocation

protocol DetailControllerDelegate: RestaurantAPI {
    func willPopViewController(_ controller: DetailController)
}
protocol DetailHeaderDelegate : AnyObject {
    func handleDismissDetailPage()
    func handleLikeRestaurant()
    func handleShareRestaurant()
}
protocol DetailCellDelegate : AnyObject {
    func shouldCellExpand(_ isExpanded: Bool, config: RestaurantDetail)
    func didTapMapOption(name: String, coordinate: CLLocationCoordinate2D)
}
