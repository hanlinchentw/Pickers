//
//  DateFormatter.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/28.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

final class DateUtils {
  static func formateDateFromTimestamp(_ timestamp: Double, withFormat format: DateUtils.format) -> String {
    let date = Date.init(timeIntervalSinceReferenceDate: timestamp)
    let formatter = DateFormatter()
    formatter.dateFormat = format.rawValue
    let formattedDate = formatter.string(from: date)
    return formattedDate
  }
}

extension DateUtils {
  enum format: String {
    case simple = "yyyy-MM-dd"
  }
}
