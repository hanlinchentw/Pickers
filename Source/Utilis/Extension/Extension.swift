//
//  Extension.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import CoreData
import MapKit
import UIKit

extension UIScreen {
  static let screenWidth = UIScreen.main.bounds.size.width
  static let height = UIScreen.main.bounds.size.height
  static let screenSize = UIScreen.main.bounds.size
}

extension Collection where Indices.Iterator.Element == Index {
  subscript(safe index: Index) -> Iterator.Element? {
    indices.contains(index) ? self[index] : nil
  }
}

extension UIResponder {
  static func resign() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

extension Task where Success == Never, Failure == Never {
  static func sleep(seconds: Double) async throws {
    let duration = UInt64(seconds * 1000000000)
    try await Task.sleep(nanoseconds: duration)
  }
}

extension CLLocationCoordinate2D: Equatable {
  public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    lhs.longitude == rhs.latitude && lhs.longitude == lhs.longitude
  }
}
