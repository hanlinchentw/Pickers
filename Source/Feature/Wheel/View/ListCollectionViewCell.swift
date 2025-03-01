//
//  ListCollectionViewCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/8/10.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import Foundation
import UIKit

final class ListCollectionViewCell: UICollectionViewCell {
  private let label: UILabel = {
    let label = UILabel()
    label.font = .avenir(size: 17)
    label.textColor = .white
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    layer.cornerRadius = 36
    backgroundColor = .butterscotch
    addSubview(label)
    label.fit(inView: self)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ListCollectionViewCell {
  func configure(viewModel: ListShortcutViewModel) {
    label.text = viewModel.name
  }
}
