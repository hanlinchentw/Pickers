//
//  UILabel+Extensions.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/21.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit


extension UILabel {
  func changeLabelWithBounceAnimation(changeTo label: String){
    let zoomAnimation = CGAffineTransform(scaleX: 1.5, y: 1.5)

    UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCrossDissolve) {

      self.transform = zoomAnimation
    } completion: { (_) in
      UIView.animate(withDuration: 0.6, delay: 0,
                     usingSpringWithDamping: 0.5,
                     initialSpringVelocity: 0.2,
                     options: .curveEaseOut) {
        self.transform = .identity
      }
    }
  }

  convenience init(_ text: String, font: UIFont, color: UIColor) {
    self.init(frame: .zero)
    self.text = text
    self.font = font
    self.textColor = color
  }
}
