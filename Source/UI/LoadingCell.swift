//
//  LoadingCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/11/9.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {
  // MARK: - Properties

  public let indicator = UIActivityIndicatorView()

  // MARK: - Lifecycle

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = .white
    addSubview(indicator)
    indicator.center(inView: self)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
