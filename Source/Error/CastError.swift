//
//  CastError.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/21.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation

struct CastError<ExpectedType>: Error {
  let actualValue: Any
  let expectedType: ExpectedType.Type
}
