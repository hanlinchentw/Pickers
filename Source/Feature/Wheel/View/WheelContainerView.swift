//
//  WheelContainerView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/4/4.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import UIKit

final class WheelContainerView: UIView {
  var onClickItem: ((CALayer) -> Void)?

  override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)

    let touch = touches.first

    guard let point = touch?.location(in: self) else { return }
    let sublayers = layer.sublayers?.compactMap { $0 as? CAShapeLayer }

    for layer in sublayers ?? [] {
      if let path = layer.path, path.contains(point) {
        onClickItem?(layer)
      }
    }
  }
}
