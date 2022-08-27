//
//  NSAttributedString+Extensions.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/27.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit
typealias Attributes = [NSAttributedString.Key : Any]
extension Attributes {
  static let black: Attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
  static let lightGray: Attributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
  static let systemYellow: Attributes = [NSAttributedString.Key.foregroundColor: UIColor.systemYellow]

  static let arial14: Attributes = [NSAttributedString.Key.font: UIFont.arialMT]

  static func attributes(_ attributes: Array<Attributes>) -> Attributes {
    var result = Attributes()
    for attribute in attributes {
      attribute.keys.forEach { key in
        let value = attribute[key]
        result[key] = value
      }
    }
    return result
  }
}
