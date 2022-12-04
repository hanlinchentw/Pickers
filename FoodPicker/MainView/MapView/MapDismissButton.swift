//
//  MapDismissButton.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/7.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit
import Combine

class MapDismissButton: UIButton {
  private let badgeLabel: UILabel = {
    let label = UILabel.init("2", font: UIFont(name: "Avenir", size: 10)!, color: .white)
    label.layer.cornerRadius = 8
    label.backgroundColor = .butterscotch
    label.clipsToBounds = true
    label.textAlignment = .center
    return label
  }()

  private var set = Set<AnyCancellable>()

  init() {
    super.init(frame: .zero)
    layer.cornerRadius = 12
    backgroundColor = .white
    setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
    tintColor = .butterscotch
    setUpBadgeLabel()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
extension MapDismissButton {
  func bindBadgeNumber(badgeNumber: Published<Int>.Publisher) {
    badgeNumber
      .map { String($0) }
      .assign(to: \.text, on: badgeLabel)
      .store(in: &set)
  }
}

// MARK: - UI setup
extension MapDismissButton {
  func setUpBadgeLabel() {
    addSubview(badgeLabel)
    badgeLabel.anchor(top: topAnchor, right: rightAnchor)
    badgeLabel.setDimension(width: 16, height: 16)
  }
}
