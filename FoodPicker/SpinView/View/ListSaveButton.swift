//
//  ListSaveButton.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/27.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import UIKit

class ListSaveButton: UIButton {
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .butterscotch
    setTitle("Save list", for: .normal)
    setTitleColor(UIColor.white, for: .normal)
    titleLabel?.font = UIFont(name: "Arial-BoldMT", size: 14)
    layer.cornerRadius = 8
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
