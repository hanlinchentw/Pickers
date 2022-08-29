//
//  PresentHelper.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/20.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit

final class PresentHelper {
  static var topViewController: UIViewController? {
    return UIApplication.shared.keyWindow?.rootViewController
  }

  static func presentPopupViewWithoutButton(title: String, subtitle: String) {
    let popup = PopupView(title: title, titleFont: 24, subtitle: subtitle, subtitleFont: 16, withButton: false)
    guard let window = UIApplication.shared.windows.first else { fatalError("DEBUG: Keywindow isn't existed.") }
    window.addSubview(popup)
  }

  static func presentPopupViewWithButton(title: String, subtitle: String, buttonText: String, action: @escaping() -> Void) {
    let popup = PopupView(title: title, titleFont: 24, subtitle: subtitle, subtitleFont: 16, withButton: true, buttonTitle: buttonText, action: action)
    guard let window = UIApplication.shared.windows.first else { fatalError("DEBUG: Keywindow isn't existed.") }
    window.addSubview(popup)
  }
}
