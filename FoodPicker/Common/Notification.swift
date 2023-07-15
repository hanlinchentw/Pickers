//
//  Notification.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/7/15.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation

extension Notification.Name {
	static var exploreSlidingSheetHeightDidChange: Self { identifier(withTitle: #function) }
	
	static func identifier(withTitle title: String) -> Notification.Name {
		Notification.Name(rawValue: "Notify" + title)
	}
}
