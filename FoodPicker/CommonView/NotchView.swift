//
//  notchView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/27.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import UIKit

class NotchView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
		backgroundColor = .init(white: 0.2, alpha: 0.4)
    layer.cornerRadius = 4 / 2
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
