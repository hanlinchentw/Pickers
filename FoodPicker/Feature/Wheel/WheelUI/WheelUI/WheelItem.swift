//
//  WheelItem.swift
//  WheelSwift
//
//  Created by Ahmed Nasser on 3/1/19.
//  Copyright © 2019 Ahmed Nasser. All rights reserved.
//

import Foundation
import UIKit

public class WheelItem: NSObject{
	public var id : String
	var title :String?
	var titleColor :UIColor?
	var itemColor :UIColor?
	public init (id: String, title :String ,titleColor:UIColor ,itemColor:UIColor){
		self.id = id
		self.title = title
		self.titleColor = titleColor
		self.itemColor = itemColor
	}
}
