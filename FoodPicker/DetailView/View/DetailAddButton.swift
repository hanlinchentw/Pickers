//
//  DetailAddButton.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/20.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit

class DetailAddButton: UIButton {
  let onPress: () -> Void
  
  init(onPress: @escaping () -> Void) {
    self.onPress = onPress
    super.init(frame: .zero)

    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor.customblack.cgColor
    self.layer.shadowOpacity = 0.3
    self.layer.shadowOffset = CGSize(width: 0, height: 1)
    self.layer.shadowRadius = 3
    self.addTarget(self, action: #selector(handleSelectButtonTapped), for: .touchUpInside)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc func handleSelectButtonTapped(){
    onPress()
  }
}
