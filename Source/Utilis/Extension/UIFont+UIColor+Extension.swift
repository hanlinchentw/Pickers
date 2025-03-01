//
//  UIFont+UIColor+Extension.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/1.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import SwiftUI
import UIKit

extension UILabel {
  @discardableResult
  func normal(size: CGFloat) -> Self {
    font = UIFont.avenir(size: size)
    return self
  }

  @discardableResult
  func bold(size: CGFloat) -> Self {
    font = UIFont.avenirBold(size: size)
    return self
  }
}

extension UIFont {
  static func avenir(size: CGFloat) -> UIFont {
    UIFont(name: "Avenir", size: size) ?? UIFont()
  }

  static func avenirBold(size: CGFloat) -> UIFont {
    UIFont(name: "AvenirNext-Bold", size: size) ?? UIFont()
  }
}

extension UIColor {
  @nonobjc class var denimBlue: UIColor {
    UIColor(red: 60.0 / 255.0, green: 89.0 / 255.0, blue: 157.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var backgroundColor: UIColor {
    UIColor(white: 235 / 255.0, alpha: 1.0)
  }

  @nonobjc class var veryLightPinkTwo: UIColor {
    UIColor(white: 216.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var customblack: UIColor {
    UIColor(white: 51.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var butterscotch: UIColor {
    UIColor(red: 1.0, green: 192.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var freshGreen: UIColor {
    UIColor(red: 127.0 / 255.0, green: 203.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var pale: UIColor {
    UIColor(red: 1.0, green: 238.0 / 255.0, blue: 207.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var gray: UIColor {
    UIColor(white: 151.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var errorRed: UIColor {
    UIColor(red: 231.0 / 255.0, green: 102.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var lightlightGray: UIColor {
    UIColor(white: 238.0 / 255.0, alpha: 1.0)
  }
}
