//
//  WheelViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/22.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit

final class WheelViewController: UIViewController {
  var presenter: WheelPresenter

  private var listMenuView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 16
    return view
  }()

  private lazy var wheel: Wheel = {
    let wheel = Wheel(radius: 330 / 2)
    wheel.animateLanding = false
    wheel.delegate = presenter
    wheel.dataSource = presenter
    wheel.setDimension(width: 330, height: 330)
    return wheel
  }()

  private lazy var actionButton: UIButton = {
    let button = UIButton()
    var configuration = UIButton.Configuration.plain()
    configuration.image = UIImage(named: R.image.btnSpin.name)?.withRenderingMode(.alwaysOriginal)
    button.configuration = configuration
    button.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    return button
  }()

  private lazy var selectionListView = WheelSelectionListView(delegate: presenter)

  init(presenter: WheelPresenter) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupWheelUI()
    presenter.onViewDidLoad()
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
  func refreshView() {
    presenter.refreshWheel()
    wheel.reloadData()
    selectionListView.refresh()
  }
}
