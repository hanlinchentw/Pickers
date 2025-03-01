//
//  WheelSelectionListViewCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/8/3.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import Kingfisher
import Reusable
import UIKit

final class WheelSelectionListViewCell: UITableViewCell, Reusable {
  private let thumbnailView: UIImageView = {
    let thumb = UIImageView()
    thumb.layer.cornerRadius = 12
    thumb.clipsToBounds = true
    return thumb
  }()

  private let label: UILabel = .init().bold(size: 14)

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension WheelSelectionListViewCell {
  func configure(viewModel: PlaceViewModel) {
    if let urlString = viewModel.imageUrl, let url = URL(string: urlString) {
      thumbnailView.kf.setImage(with: url)
    }
    label.text = viewModel.name
  }
}

private extension WheelSelectionListViewCell {
  func setupUI() {
    addSubview(thumbnailView)
    thumbnailView.centerY(inView: self)
    thumbnailView.setDimension(width: 72, height: 72)
    thumbnailView.anchor(left: leftAnchor, paddingLeft: 16)

    addSubview(label)
    label.centerY(inView: self)
    label.anchor(left: thumbnailView.rightAnchor, paddingLeft: 16)
  }
}
