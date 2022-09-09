//
//  SecondPresenter.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/20.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit
import Combine

class SecondRowPresenter: DetailRowPresenter {
  var delegate: DetailCellDelegate?
  let detail: Detail
  let config: DetailConfig
  var isExpanded: Bool

  init(_ config: DetailConfig, detail: Detail, isExpanded: Bool) {
    self.detail = detail
    self.isExpanded = isExpanded
    self.config = config
  }

  var icon: String? {
    return "icnClockXs"
  }
  
  var iconIsHidden: Bool {
    return false
  }
  
  var title: String {
    return "Time"
  }

  var content: NSAttributedString? {
    return businessHourSub
  }
  
  var rightText: String? {
    return nil
  }
  
  var actionButtonIsHidden: Bool {
    return false
  }
  
  var actionButtonImageName: String? {
    return isExpanded ? "icnArrowUp" : "icnArrowDown"
  }

  func actionButtonTapped() {
    delegate?.didTapActionButton(config)
  }

  let date = Calendar.current.dateComponents(in: TimeZone.current, from: Date())

  var businessHourSub : NSAttributedString {
    guard let weekDayNum = date.weekday else { return NSAttributedString(string: "No Providing")}
    guard let hours = detail.hours?[0] else { return NSAttributedString(string: "No Providing")}
    var isOpen :String {
      return detail.isClosed ?? true ? "Closed" : "Open"
    }
    var numofDayTransfromToYelp : Int {
      switch weekDayNum {
      case 1: return 6
      default: return weekDayNum - 2
      }
    }
    func getInterval(numofDayfromYelp: Int) -> String{
      var interval = ""
      hours.open.forEach { (day) in
        if day.day == numofDayfromYelp {
          var start = day.start
          start.insert(":", at: start.index(start.startIndex, offsetBy: 2))
          var end = day.end
          end.insert(":", at: end.index(end.startIndex, offsetBy: 2))
          interval = "\(start) - \(end)"
        }
      }
      return interval
    }
    let weekArray = ["Monday            ",
                     "            Tuesday           ",
                     "            Wednesday      ",
                     "            Thursday          ",
                     "            Friday               ",
                     "            Saturday           ",
                     "            Sunday             "]
    var hoursArray : [String] = []
    for i in 0...6 {
      let hours = getInterval(numofDayfromYelp: i)
      if hours == "" {
        hoursArray.append("\(weekArray[i])Closed")
      }else {
        hoursArray.append("\(weekArray[i])\(getInterval(numofDayfromYelp: i))")
      }
    }
    var expandedSheet : String {
      var contain = ""
      hoursArray.forEach { (day) in
        contain +=  "\(day)\n\n"
      }
      return contain
    }

    let isOpenColor : UIColor = isOpen == "Open" ? .freshGreen : .systemRed


    let attributedString = NSMutableAttributedString(string: "\(isOpen)・",
                                                     attributes: [NSAttributedString.Key.foregroundColor: isOpenColor])
    if isExpanded {
      attributedString.append(NSAttributedString(string: "\(expandedSheet)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.customblack,
                                                                                          NSAttributedString.Key.font : UIFont.arial14MT]))
    }else {

      attributedString.append(NSAttributedString(string: "\(getDayFromNum(weekDayNum))    \(getInterval(numofDayfromYelp: numofDayTransfromToYelp))", attributes: [NSAttributedString.Key.foregroundColor : UIColor.customblack,
                                                                                                                                                                        NSAttributedString.Key.font : UIFont(name: "Arial-BoldMT", size: 14)]))

    }
    return attributedString
  }
  func getDayFromNum(_ num: Int) -> String {
    switch num {
    case 2: return "Monday"
    case 3: return "Tuesday"
    case 4: return "Wednesday"
    case 5: return "Thursday"
    case 6: return "Friday"
    case 7: return "Saturday"
    case 1: return "Sunday"
    default: return "Sunday"
    }
  }
}
