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
		return isExpanded ? "All avaliable time" : "Opening Time"
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
		
		let openHours = detail.hours?[0]
		
		var numofDayTransfromToYelp : Int {
			switch weekDayNum {
			case 1: return 6
			default: return weekDayNum - 2
			}
		}
		
		let paragraphStyle = NSMutableParagraphStyle()
		let tab = NSTextTab(textAlignment: .left, location: 100, options: [:])
		paragraphStyle.tabStops = [tab]
		
		let weekArray = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
		var everydayOpenInterval : [String] = []
		for (index, day) in weekArray.enumerated(){
			let openInterval = getInterval(hours: openHours, numofDayfromYelp: index)
			if openInterval == "" {
				everydayOpenInterval.append("\(day)\tNo providing.\n\n")
			}else {
				everydayOpenInterval.append("\(day)\t\(openInterval)\n\n")
			}
		}

		if isExpanded {
			let expandedSheet = everydayOpenInterval.reduce("", { $0 + $1 })
			return NSMutableAttributedString(
				string: expandedSheet,
				attributes: .attributes([[NSAttributedString.Key.paragraphStyle: paragraphStyle], .black])
			)
		}else {
			return NSAttributedString(
				string: everydayOpenInterval[weekDayNum - 2],
				attributes: .attributes([[NSAttributedString.Key.paragraphStyle: paragraphStyle], .black, .arial14Bold])
			)
		}
	}
	
	func getInterval(hours: Open?, numofDayfromYelp: Int) -> String{
		var interval = ""
		hours?.open.forEach { (day) in
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
}
