//
//  CreateListCollectionViewCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/8/10.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import Foundation
import UIKit

final class CreateListCollectionViewCell: UICollectionViewCell {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension CreateListCollectionViewCell {
  func setupUI() {
    let strokeLayer = CAShapeLayer()
    strokeLayer.strokeColor = UIColor.butterscotch.cgColor
    strokeLayer.lineDashPattern = [4, 2]
    strokeLayer.lineWidth = 1
    strokeLayer.borderWidth = 1
    strokeLayer.cornerRadius = 32
    layer.addSublayer(strokeLayer)

    let plusImage = UIImageView()
    plusImage.image = UIImage(systemName: "plus")
    plusImage.tintColor = .butterscotch
    addSubview(plusImage)
    plusImage.setDimension(width: 24, height: 24)
    plusImage.centerY(inView: self)
  }
}
