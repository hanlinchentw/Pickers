//
//  Distance.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/1/12.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import Foundation

enum Distance {
  case meter(Double)
  case kilometer(Double)

  var value: Double {
    switch self {
    case let .meter(meter):
      meter
    case let .kilometer(kilometer):
      kilometer
    }
  }

  var valueInMeters: Double {
    switch self {
    case let .meter(meter):
      meter
    case let .kilometer(kilometer):
      kilometer * 1000
    }
  }

  var unit: String {
    switch self {
    case .meter:
      "m"
    case .kilometer:
      "km"
    }
  }

  var description: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 1
    if let formattedNumber = formatter.string(from: NSNumber(value: value)) {
      return formattedNumber + unit
    }
    return "\(value.formatted())" + unit
  }
}

extension Distance: Equatable, Comparable {
  // MARK: - Equatable
  static func == (lhs: Distance, rhs: Distance) -> Bool {
    lhs.valueInMeters == rhs.valueInMeters
  }

  // MARK: - Comparable
  static func < (lhs: Distance, rhs: Distance) -> Bool {
    lhs.valueInMeters < rhs.valueInMeters
  }
}
