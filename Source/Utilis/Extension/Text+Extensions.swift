//
//  Text+Extensions.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/13.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

extension Text {
  func en12() -> Text {
    font(Font.custom("Avenir", fixedSize: 12))
  }

  func en14() -> Text {
    font(Font.custom("Avenir", fixedSize: 14))
  }

  func en14Bold() -> Text {
    font(Font.custom("AvenirNext-Bold", fixedSize: 14))
  }

  func en16() -> Text {
    font(Font.custom("Avenir", fixedSize: 16))
  }

  func en18() -> Text {
    font(Font.custom("Avenir", fixedSize: 18))
  }

  func en18Medium() -> Text {
    font(Font.custom("AvenirNext-Medium", fixedSize: 18))
  }

  func en16Bold() -> Text {
    font(Font.custom("AvenirNext-Bold", fixedSize: 16))
  }

  func en18Bold() -> Text {
    font(Font.custom("AvenirNext-Bold", fixedSize: 18))
  }

  func en24Bold() -> Text {
    font(Font.custom("AvenirNext-Bold", fixedSize: 24))
  }

  func en32Bold() -> Text {
    font(Font.custom("AvenirNext-Bold", fixedSize: 32))
  }

  private func avenirFont(size: CGFloat, weight: Font.Weight = .regular) -> Text {
    font(Font.custom("Avenir", size: size).weight(weight))
  }

  func ultraLight(size: Double) -> Text {
    avenirFont(size: size, weight: .ultraLight)
  }

  func light(size: Double) -> Text {
    avenirFont(size: size, weight: .light)
  }

  func normal(size: Double) -> Text {
    avenirFont(size: size)
  }

  func medium(size: Double) -> Text {
    avenirFont(size: size, weight: .medium)
  }

  func semibold(size: Double) -> Text {
    avenirFont(size: size, weight: .semibold)
  }

  func bold(size: Double) -> Text {
    avenirFont(size: size, weight: .bold)
  }
}

extension Text {
  init?(_ content: (some Any)?) {
    guard let content else { return nil }
    self.init(verbatim: "\(content)")
  }

  init(_ text: String?) {
    self.init(verbatim: text ?? "")
  }

  init(_ args: String?...) {
    let string = args.compactMap { $0 }.reduce("") { $0 + $1 }
    self.init(string)
  }
}
