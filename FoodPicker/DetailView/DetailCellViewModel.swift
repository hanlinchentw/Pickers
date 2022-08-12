//
//  DetailViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/31.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

struct DetailCellViewModel {
//    let restaurant : Restaurant
//    var config : RestaurantDetail?
//    var detail : Details?
//    let isExpanded : Bool
//    init(restaurant: Restaurant, config: RestaurantDetail?, isExpanded: Bool) {
//        self.restaurant = restaurant
//        self.isExpanded = isExpanded
//        if let config = config {
//            self.config = config
//        }
//        if let detail = restaurant.details {
//            self.detail = detail
//        }
//    }
    //MARK: - Common
//    var titleText : String {
//        switch config {
//        case .main: return restaurant.name
//        case .businessHour: return "Time"
//        case .address: return "Address"
//        case .phone: return "Number"
//        case .none: return ""
//        }
//    }
//    
//    var heightForEachCell : CGFloat  {
//        switch config {
//        case .main: return 72
//        case .businessHour: return 72
//        case .address: return 72
//        case .phone: return 72
//        case .none: return 0
//        }
//    }
//    
//    var subtitleText : NSAttributedString {
//        switch config {
//        case .main: return mainSub
//        case .businessHour: return businessHourSub
//        case .address: return addressSub
//        case .phone: return NSAttributedString(string:phoneSub ?? "No providing")
//        case .none: return NSAttributedString()
//        }
//    }
//    
//    var iconImageName : String {
//        switch config {
//        case .main: return ""
//        case .businessHour: return "icnClockXs"
//        case .address: return "icnLocationXs"
//        case .phone: return "icnCallXs"
//        case .none: return ""
//        }
//    }
//    var actionButtonImageName : String {
//        switch config {
//        case .main: return ""
//        case .businessHour: return  isExpanded ? "icnArrowUp" : "icnArrowDown"
//        case .address: return "btnGoogleMaps"
//        case .phone: return "btnCall"
//        case .none: return ""
//        }
//    }
//    var shouldShadowTurnOff : Bool{
//        switch config {
//        case .address, .phone: return false
//        default: return true
//        }
//    }
//    //MARK: - Main
//    var mainSub : NSAttributedString {
//        let attributedString = NSMutableAttributedString(string: "\(restaurant.price) ・ \(restaurant.categories)",
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
//        return attributedString
//    }
//    var rating : Double {
//        return restaurant.rating
//    }
//    
//    var reviewCount : Int {
//        return restaurant.reviewCount
//    }
//    //MARK: - Business Hour
//    let date = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
//    
//    var businessHourSub : NSAttributedString {
//        guard let detail = detail else { return NSAttributedString(string: "No Providing") }
//        guard let weekDayNum = date.weekday else { return NSAttributedString(string: "No Providing")}
//        guard let hours = detail.hours?[0] else { return NSAttributedString(string: "No Providing")}
//        var isOpen :String {
//            return restaurant.isClosed ?? true ? "Closed" : "Open"
//        }
//        var numofDayTransfromToYelp : Int {
//            switch weekDayNum {
//            case 1: return 6
//            default: return weekDayNum - 2
//            }
//        }
//        func getInterval(numofDayfromYelp: Int) -> String{
//            var interval = ""
//            hours.open.forEach { (day) in
//                if day.day == numofDayfromYelp {
//                    var start = day.start
//                    start.insert(":", at: start.index(start.startIndex, offsetBy: 2))
//                    var end = day.end
//                    end.insert(":", at: end.index(end.startIndex, offsetBy: 2))
//                    interval = "\(start) - \(end)"
//                }
//            }
//            return interval
//        }
//        let weekArray = ["Monday            ",
//                         "            Tuesday           ",
//                         "            Wednesday      ",
//                         "            Thursday          ",
//                         "            Friday               ",
//                         "            Saturday           ",
//                         "            Sunday             "]
//        var hoursArray : [String] = []
//        for i in 0...6 {
//            let hours = getInterval(numofDayfromYelp: i)
//            if hours == "" {
//               hoursArray.append("\(weekArray[i])Closed")
//            }else {
//                hoursArray.append("\(weekArray[i])\(getInterval(numofDayfromYelp: i))")
//            }
//        }
//        var expandedSheet : String {
//            var contain = ""
//            hoursArray.forEach { (day) in
//                contain +=  "\(day)\n\n"
//            }
//            return contain
//        }
//        
//        let isOpenColor : UIColor = isOpen == "Open" ? .freshGreen : .systemRed
//        
//        
//        let attributedString = NSMutableAttributedString(string: "\(isOpen)・",
//        attributes: [NSAttributedString.Key.foregroundColor: isOpenColor])
//        if isExpanded {
//            attributedString.append(NSAttributedString(string: "\(expandedSheet)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.customblack,
//                                                                                                NSAttributedString.Key.font : UIFont.arialMT]))
//        }else {
//            
//            attributedString.append(NSAttributedString(string: "\(getDayFromNum(num: weekDayNum))    \(getInterval(numofDayfromYelp: numofDayTransfromToYelp))", attributes: [NSAttributedString.Key.foregroundColor : UIColor.customblack,
//            NSAttributedString.Key.font : UIFont(name: "Arial-BoldMT", size: 14)]))
//            
//        }
//        return attributedString
//    }
//    func getDayFromNum(num: Int) -> String {
//        switch num {
//        case 2: return "Monday"
//        case 3: return "Tuesday"
//        case 4: return "Wednesday"
//        case 5: return "Thursday"
//        case 6: return "Friday"
//        case 7: return "Saturday"
//        case 1: return "Sunday"
//        default: return "Sunday"
//        }
//    }
//    
//    
//    //MARK: - Address
//    var addressSub : NSAttributedString {
//        guard let detail = detail,
//            let address : String = detail.location?.displayAddress.reduce("",{$0 + " " + $1})
//            else { return NSAttributedString(string: "No Providing") }
//        let attributedString = NSMutableAttributedString(string: address,
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor.customblack])
//        return attributedString
//    }
//    //MARK: - Phone Number
//    var phoneSub : String? {
//        return detail?.displayPhone
//    }
}

