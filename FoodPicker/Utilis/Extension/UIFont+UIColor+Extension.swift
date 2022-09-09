//
//  UIFont+UIColor+Extension.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/1.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit

extension UIFont {
  static var arial12MT: UIFont {
    return UIFont(name: "ArialMT", size: 12) ?? UIFont()
  }

  static var arial14MT: UIFont {
    return UIFont(name: "ArialMT", size: 14) ?? UIFont()
  }

  static var arial14BoldMT: UIFont {
    return UIFont(name: "Arial-BoldMT", size: 14) ?? UIFont()
  }

  static var arial16BoldMT: UIFont {
    return UIFont(name: "Arial-BoldMT", size: 16) ?? UIFont()
  }
}
extension UIColor {
  @nonobjc class var denimBlue: UIColor {
    return UIColor(red: 60.0 / 255.0, green: 89.0 / 255.0, blue: 157.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var backgroundColor: UIColor {
    return UIColor(white: 238 / 255.0, alpha: 1.0)
  }

  @nonobjc class var veryLightPinkTwo: UIColor {
    return UIColor(white: 216.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var customblack: UIColor {
    return UIColor(white: 51.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var butterscotch: UIColor {
    return UIColor(red: 1.0, green: 192.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var freshGreen: UIColor {
    return UIColor(red: 127.0 / 255.0, green: 203.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var pale: UIColor {
    return UIColor(red: 1.0, green: 238.0 / 255.0, blue: 207.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var gray: UIColor {
    return UIColor(white: 151.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var errorRed: UIColor {
    return UIColor(red: 231.0 / 255.0, green: 102.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var lightlightGray: UIColor {
    return UIColor(white: 238.0 / 255.0, alpha: 1.0)
  }

}
