//
//  CardCellViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/6.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import CoreLocation

struct CardCellViewModel {
    
    var restaurant : Restaurant
    
    var priceString : NSAttributedString? {
        let attributedTitle =  NSMutableAttributedString(string: "\(restaurant.price)・\(restaurant.type)・\(distance) m", attributes:
            [NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 14),
             NSAttributedString.Key.foregroundColor:UIColor.gray ])
        return attributedTitle
    }
    
    var selectButtonImage : UIImage? {
        return restaurant.isSelected  ? UIImage(named: "icnOvalSelected") :  UIImage(named: "addL")
    }
    
    var likeButtonImagename : String {
        return restaurant.isLiked ? "btnBookmarkHeartPressed" : "icnHeart"
    }
    
    var businessString : NSAttributedString? {
        
        let closedText =  NSMutableAttributedString(string: "CLOSED", attributes:
        [NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 14),
         NSAttributedString.Key.foregroundColor:UIColor.systemRed])
        let openText =  NSMutableAttributedString(string: "OPEN", attributes:
        [NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 14),
         NSAttributedString.Key.foregroundColor:UIColor.freshGreen])
        
        return restaurant.isClosed ?? true ? closedText : openText
    }
    
    var ratedString : NSAttributedString? {
        let attributedTitle =  NSMutableAttributedString(string: "★ ", attributes:
            [NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 14),
             NSAttributedString.Key.foregroundColor:UIColor.butterscotch])
        attributedTitle.append(NSAttributedString(string: "\(restaurant.rating)", attributes:
        [NSAttributedString.Key.foregroundColor : UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1),
         NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 14), ]))
        attributedTitle.append(NSAttributedString(string: " (\(restaurant.reviewCount))", attributes:
            [NSAttributedString.Key.foregroundColor : UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1),
             NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 14), ]))
        
        
        return attributedTitle
    }
    
    var distance : Int {
        let location = CLLocation(latitude: restaurant.coordinates.latitude,
                                  longitude: restaurant.coordinates.longitude)
        guard let currentLocation = LocationHandler.shared.locationManager.location else { return 1000 }
        let distance = location.distance(from: currentLocation)
        return Int(distance)
    }
    
    
    init(restaurant : Restaurant) {
        self.restaurant = restaurant
    }
    
}
