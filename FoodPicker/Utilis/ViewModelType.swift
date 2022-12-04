//
//  PresenterType.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/3.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

protocol ViewModelType {
  associatedtype Input
  associatedtype Output
  var inputs: Input { get }
  var outputs: Output { get }
}
