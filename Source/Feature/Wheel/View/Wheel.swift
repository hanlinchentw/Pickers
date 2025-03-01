//
//  Wheel.swift
//  LuckyWheel
//
//  Created by Ahmed Nasser on 12/25/18.
//  Copyright © 2018 Ahmed Nasser. All rights reserved.
//

import CoreGraphics
import Foundation
import UIKit

public protocol WheelDelegate: AnyObject {
  func onClickItem(id: String)
  func wheelDidChangeValue(_ newValue: Int)
}

public protocol WheelDataSource: AnyObject {
  func numberOfSections() -> Int
  func itemsForSections() -> [WheelItem]
}

public final class Wheel: UIView {
  public var delegate: WheelDelegate?
  public var dataSource: WheelDataSource? {
    didSet {
      reloadData()
    }
  }

  public var animateLanding = false
  public var aCircleTime: Double = 1.5

  var container = WheelContainerView()

  var timer: Timer?
  var isAnimating = false
  var selectedSectionIndex: Int = 0
  var landingPosition: LandingPostion = .top

  var angleSize: CGFloat {
    guard let dataSource else {
      return 0
    }
    return CGFloat(360.0 / Double(dataSource.numberOfSections()))
  }

  var radius: CGFloat

  private lazy var actionButton: UIButton = {
    let button = UIButton()
    var configuration = UIButton.Configuration.plain()
    configuration.image = UIImage(named: R.image.btnSpin.name)?.withRenderingMode(.alwaysOriginal)
    button.configuration = configuration
    button.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    return button
  }()

  public init(radius: CGFloat) {
    self.radius = radius
    super.init(frame: CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2))
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func reloadData() {
    drawWheel()
  }

  @objc func didTapActionButton() {
    actionButton.isUserInteractionEnabled = false
    actionButton.performBounceAnimataion(scale: 1.1, duration: 0.1)
    start { self.actionButton.isUserInteractionEnabled = true }
  }

  public func setTarget(section: Int) {
    assert(section <= (dataSource?.numberOfSections())!, "selected Section is out of bounds")
    selectedSectionIndex = section
  }

  public func start(completion: (() -> Void)? = nil) {
    guard let dataSource else { return }
    setTarget(section: Int.random(in: 0..<dataSource.numberOfSections()))
    let finalAngle = -angleToRadian(angleSize * CGFloat(selectedSectionIndex)) + (12 * .pi)
    let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    rotationAnimation.toValue = finalAngle
    rotationAnimation.isRemovedOnCompletion = false
    rotationAnimation.duration = 6
    rotationAnimation.fillMode = .both
    rotationAnimation.timingFunction = .init(name: .easeInEaseOut)

    CATransaction.begin()
    CATransaction.setCompletionBlock {
      completion?()
    }

    layer.add(rotationAnimation, forKey: nil)
    if animateLanding,
       let selectedSection = container.layer.sublayers?.first(where: { $0.name == dataSource.itemsForSections()[selectedSectionIndex].id }) {
      let animation = CABasicAnimation(keyPath: "position")
      animation.fromValue = CGPoint(x: 0, y: 0)
      animation.toValue = CGPoint(x: 100, y: 100)
      animation.duration = 1.0
      animation.repeatCount = .infinity
      selectedSection.add(animation, forKey: "positionAnimation")
    }
    CATransaction.commit()
    delegate?.wheelDidChangeValue(selectedSectionIndex)
  }
}

extension Wheel {
  enum LandingPostion: Int {
    case top = 270
    case left = 180
    case right = 360
    case bottom = 90
  }
}

// MARK: - Graphic

extension Wheel {
  private func drawWheel() {
    guard let dataSource else { return }
    assert(dataSource.numberOfSections() == dataSource.itemsForSections().count, "number of sections must be equal as items")
    let landingPostion: LandingPostion = .top
    container.removeFromSuperview()
    container = WheelContainerView()

    var start = CGFloat(landingPostion.rawValue) - angleSize / 2
    var end = CGFloat(landingPostion.rawValue) + angleSize / 2
    var angles: [CGFloat] = []

    for index in 0..<dataSource.numberOfSections() {
      angles.append(angleToRadian(start) + angleToRadian(angleSize) / 2)
      let shapeLayer = createShapeLayer(start: start, end: end, item: dataSource.itemsForSections()[index])
      container.layer.addSublayer(shapeLayer)
      start = CGFloat(fmodf(Float(start + angleSize), 360.0))
      end = CGFloat(fmodf(Float(end + angleSize), 360.0))
    }
    let labelsView = WheelItemText(angles: angles, withRadius: Float(radius), items: dataSource.itemsForSections())
    labelsView.frame = bounds
    container.frame = bounds
    addSubview(container)
    container.addSubview(labelsView)

    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapWheel))
    container.addGestureRecognizer(tap)
    container.onClickItem = { [weak self] shape in
      self?.delegate?.onClickItem(id: shape.name ?? "")
    }
  }

  private func createShapeLayer(start: CGFloat, end: CGFloat, item: WheelItem) -> CAShapeLayer {
    let path = UIBezierPath()
    let center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
    path.move(to: center)
    path.addArc(withCenter: center, radius: radius, startAngle: angleToRadian(start), endAngle: angleToRadian(end), clockwise: true)

    let layer = CAShapeLayer()
    layer.path = path.cgPath
    layer.fillColor = item.itemColor.cgColor
    layer.name = item.id
    return layer
  }

  @objc func didTapWheel() {
  }
}

// MARK: - Helper

private extension Wheel {
  private func angleToRadian(_ angle: CGFloat) -> CGFloat {
    angle * .pi / 180.0
  }
}
