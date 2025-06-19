//
//  WheelViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/22.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit

struct WheelConfiguration {
  let buttonEnable: Bool
  let diameter: CGFloat
}

final class WheelViewController: UIViewController {
  var wheelItems: [WheelItem]
  let configuration: WheelConfiguration

  private lazy var wheel: Wheel = {
    let wheel = Wheel(radius: configuration.diameter / 2)
    wheel.animateLanding = false
    wheel.delegate = self
    wheel.dataSource = self
    wheel.setDimension(width: configuration.diameter, height: configuration.diameter)
    return wheel
  }()

  private lazy var actionButton: UIButton = {
    let button = UIButton()
    button.isEnabled = configuration.buttonEnable
    var configuration = UIButton.Configuration.plain()
    configuration.image = UIImage(named: R.image.btnSpin.name)?.withRenderingMode(.alwaysOriginal)
    button.configuration = configuration
    button.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    return button
  }()

  init(wheelItems: [WheelItem], configuration: WheelConfiguration) {
    self.wheelItems = wheelItems
    self.configuration = configuration
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupWheelUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    wheel.reloadData()
  }

  @objc func didTapActionButton() {
    actionButton.isUserInteractionEnabled = false
    actionButton.performBounceAnimataion(scale: 1.1, duration: 0.1)
    wheel.start { self.actionButton.isUserInteractionEnabled = true }
  }
}

extension WheelViewController {
  func setupWheelUI() {
    view.addSubview(wheel)
    wheel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
    wheel.centerX(inView: view)
    view.addSubview(actionButton)
    actionButton.center(inView: wheel)
  }
}

extension WheelViewController: WheelView {
  func refreshView(with data: [WheelItem]) {
		wheelItems = data
    wheel.reloadData()
  }
}
