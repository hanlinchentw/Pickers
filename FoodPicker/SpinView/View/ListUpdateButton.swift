//
//  ListUpdateButton.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/27.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import UIKit

class ListUpdateButton: UIButton {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setTitle("Update", for: .normal)
    setTitleColor(.butterscotch, for: .normal)
    layer.borderColor = UIColor.butterscotch.cgColor
    layer.cornerRadius = 8
    layer.borderWidth = 0.75
    isHidden = true
    backgroundColor = .white
    titleLabel?.font = UIFont.arialMT
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
