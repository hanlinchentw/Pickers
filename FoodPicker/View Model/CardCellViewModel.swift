//
//  CardCellViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/6.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

struct CardCellViewModel {
    
    var restaurant : Restaurant
    
    var priceString : NSAttributedString? {
        let attributedTitle =  NSMutableAttributedString(string: "\(restaurant.price) ・ \(restaurant.type)", attributes:
            [NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 14),
             NSAttributedString.Key.foregroundColor:UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1) ])
      
        return attributedTitle
    }
    
    static var numberFormatter : NumberFormatter{
        let nf = NumberFormatter()
        nf.numberStyle = .none
        nf.maximumFractionDigits = 0
        
        return nf
    }
    
    var formattedDistance : String? {
        return CardCellViewModel.numberFormatter.string(from: restaurant.distance as NSNumber)
    }
    
    var selectButtonImage : UIImage? {
        return restaurant.isSelected  ? UIImage(named: "icnOvalSelected") :  UIImage(named: "icnOval")
    }
    
    var heartColor : UIColor {
        return restaurant.isLiked ? .red : .clear
    }
    
    var businessString : NSAttributedString? {
        
        let closedText =  NSMutableAttributedString(string: "CLOSED", attributes:
        [NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 14),
         NSAttributedString.Key.foregroundColor:UIColor.systemRed])
        let openText =  NSMutableAttributedString(string: "OPEN", attributes:
        [NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 14),
         NSAttributedString.Key.foregroundColor:UIColor.freshGreen])
        
        return restaurant.isClosed ? closedText : openText
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
        
        guard let distance = formattedDistance else { return attributedTitle }
        attributedTitle.append(NSAttributedString(string: "・\(distance) m away", attributes:
        [NSAttributedString.Key.foregroundColor : UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1),
         NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 14), ]))
        return attributedTitle
    }
    
    init(restaurant : Restaurant) {
        self.restaurant = restaurant
    }
    
}
