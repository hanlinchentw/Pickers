//
//  WheelItem.swift
//  WheelSwift
//
//  Created by Ahmed Nasser on 3/1/19.
//  Copyright © 2019 Ahmed Nasser. All rights reserved.
//

import Foundation
import Observation
import UIKit

@Observable
public class WheelItem: NSObject {
  public var id: String
  var title: String
  var titleColor: UIColor
  var itemColor: UIColor

  public init(id: String = UUID().uuidString, title: String, titleColor: UIColor, itemColor: UIColor) {
    self.id = id
    self.title = title
    self.titleColor = titleColor
    self.itemColor = itemColor
  }
}

extension WheelItem {
  static var dummyItems: [WheelItem] {
    [
      WheelItem(title: "Picker!", titleColor: .customblack, itemColor: .pale),
      WheelItem(title: "Picker!", titleColor: .black, itemColor: .white),
      WheelItem(title: "Picker!", titleColor: .customblack, itemColor: .pale),
      WheelItem(title: "Picker!", titleColor: .black, itemColor: .white)
    ]
  }

	static func createWheel(items: [(id: String, name: String)]) -> [WheelItem] {
		items.enumerated().map { (index, item) in
			let id = item.id
			let name = item.name
			let color: UIColor = index % 2 == 0 ? .pale : .white
			return WheelItem(id: id, title: name, titleColor: .customblack, itemColor: color)
		}
	}
}
