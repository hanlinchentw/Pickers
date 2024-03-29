//
//  UIView+Extension.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/1.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit


extension UIView {
  // FOR 11 Pro max : 414 x 896
  var heightMultiplier : CGFloat {
    let screenHeight = UIScreen.main.bounds.height
    let height = screenHeight / CGFloat(896)
    return height
  }
  var widthMultiplier : CGFloat {
    let screenWidth = UIScreen.main.bounds.width
    let width = screenWidth / CGFloat(414)
    return width
  }

  var restaurantCardCGSize : CGSize {
    // Card should be : 280 * 242
    let width = widthMultiplier * CGFloat(280)
    let height = heightMultiplier * CGFloat(242)
    return CGSize(width: width, height: height)
  }

  func anchor(top: NSLayoutYAxisAnchor? = nil,
              left: NSLayoutXAxisAnchor? = nil,
              right: NSLayoutXAxisAnchor? = nil,
              bottom: NSLayoutYAxisAnchor? = nil,
              paddingTop: CGFloat = 0,
              paddingLeft: CGFloat = 0,
              paddingRight: CGFloat = 0,
              paddingBottom: CGFloat = 0,
              width: CGFloat? = nil,
              height:CGFloat? = nil){
    translatesAutoresizingMaskIntoConstraints = false

    if let top = top {
      topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
    }
    if let left = left {
      leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
    }
    if let right = right {
      rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
    }
    if let bottom = bottom {
      bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
    }
    if let width = width {
      widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    if let height = height {
      heightAnchor.constraint(equalToConstant: height).isActive = true
    }
  }
  func setDimension(width: CGFloat? = nil, height: CGFloat? = nil) {
    translatesAutoresizingMaskIntoConstraints = false
    if let width = width {
      widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    if let height = height {
      heightAnchor.constraint(equalToConstant: height).isActive = true
    }
  }

  func centerX(inView view: UIView, xConstant : CGFloat = 0){
    translatesAutoresizingMaskIntoConstraints = false
    centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: xConstant).isActive = true
  }
  func centerY(inView view: UIView, yConstant : CGFloat = 0){
    translatesAutoresizingMaskIntoConstraints = false
    centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant).isActive = true
  }
  func center(inView view: UIView, xConstant : CGFloat = 0, yConstant : CGFloat = 0){
    translatesAutoresizingMaskIntoConstraints = false
    centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant).isActive = true
    centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: xConstant).isActive = true
  }
  func fit(inView view: UIView){
    anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
  }
  func widthMutiplier(widthAnchor: NSLayoutDimension, widthMultiplier: CGFloat = 0) {
    translatesAutoresizingMaskIntoConstraints = false
    self.widthAnchor.constraint(equalTo: widthAnchor, multiplier: widthMultiplier).isActive = true

  }
  func heightMultiplier(heightAnchor: NSLayoutDimension, heightMultiplier: CGFloat = 0 ) {
    translatesAutoresizingMaskIntoConstraints = false
    self.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightMultiplier).isActive = true
  }

  func performBounceAnimataion(scale: CGFloat, duration: Double) {
    let zoomAnimation = CGAffineTransform(scaleX: scale, y: scale)

    UIView.animate(withDuration: duration, delay: 0, options: .transitionCrossDissolve) {
      self.transform = zoomAnimation
    } completion: { (_) in
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseOut) {
        self.transform = .identity
      }
    }
  }
}
