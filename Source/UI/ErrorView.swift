//
//  ErrorView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/1.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit

protocol ErrorViewDelegate: AnyObject {
  func didTapReloadButton()
}

class ErrorView: UIView {
  // MARK: - Properties

  weak var delegate: ErrorViewDelegate?
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Sorry..."
    label.font = UIFont(name: "Arial-BoldMT", size: 24)
    return label
  }()

  let descriptionLabel: UILabel = {
    let label = UILabel()
    label.text = "Something went wrong, Please try again."
    label.font = UIFont(name: "ArialMT", size: 16)
    return label
  }()

  let errorImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.image = UIImage(named: "illustrationError")?.withRenderingMode(.alwaysOriginal)
    iv.setDimension(width: 320, height: 320)
    return iv
  }()

  lazy var reloadButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Reload", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = UIFont(name: "Arial-BoldMT", size: 16)
    button.layer.cornerRadius = 24
    button.setDimension(width: 144, height: 48)
    button.backgroundColor = .butterscotch
    button.tintColor = .white
    button.addTarget(self, action: #selector(handleReloadButtonTapped), for: .touchUpInside)
    return button
  }()

  // MARK: - Initializer

  init() {
    super.init(frame: .zero)
    frame = UIScreen.main.bounds

    let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, errorImageView, reloadButton])
    stack.axis = .vertical
    stack.distribution = .fillProportionally
    stack.alignment = .center
    stack.spacing = 8

    addSubview(stack)
    stack.center(inView: self)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Seletors

extension ErrorView {
  @objc func handleReloadButtonTapped() {
    delegate?.didTapReloadButton()
  }
}
