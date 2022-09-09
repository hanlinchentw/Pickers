//
//  ToastStyleTheme.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/9.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Toast_Swift

extension ToastStyle {
  static var searchThisArea: ToastStyle {
    var style = ToastStyle()
    style.messageColor = .butterscotch
    style.cornerRadius = 22
    style.backgroundColor = .white
    style.horizontalPadding = 16
    style.messageAlignment = .center
    return style
  }
}
