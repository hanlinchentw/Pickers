//
//  StrideArray.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/3/17.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import Foundation

struct StrideArray<Element: Strideable> where Element.Stride: SignedNumeric {
  let elements: [Element]

  init(elements: [Element]) {
    // Check if the array follows a stride pattern
    guard elements.count > 1 else {
      fatalError("StrideArray must contain at least two elements")
    }

    var isValidStrideArray = true
    for idx in 1..<elements.count {
      if elements[idx].distance(to: elements[idx - 1]) != elements[1].distance(to: elements[0]) {
        isValidStrideArray = false
        break
      }
    }

    guard isValidStrideArray else {
      fatalError("Elements in StrideArray must have a consistent stride pattern")
    }

    self.elements = elements
  }

  var minValue: Element? {
    elements.min()
  }

  var maxValue: Element? {
    elements.max()
  }

  var stepSize: Element.Stride {
    guard elements.count >= 2 else {
      fatalError("StrideArray must contain at least two elements to compute step size")
    }
    return elements[0].distance(to: elements[1])
  }
}
