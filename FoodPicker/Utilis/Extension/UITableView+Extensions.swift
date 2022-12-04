//
//  UITableView+Extensions.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/27.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit

extension UITableView {
  func reloadRowSmoothly() {

  }

  func reloadDataSmoothly() {
    UIView.setAnimationsEnabled(false)
    CATransaction.begin()

    CATransaction.setCompletionBlock { () -> Void in
      UIView.setAnimationsEnabled(true)
    }

    reloadData()
    beginUpdates()
    endUpdates()

    CATransaction.commit()
  }
}
