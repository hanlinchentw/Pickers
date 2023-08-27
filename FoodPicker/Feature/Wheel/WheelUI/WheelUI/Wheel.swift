//
//  LuckyWheel.swift
//  LuckyWheel
//
//  Created by Ahmed Nasser on 12/25/18.
//  Copyright © 2018 Ahmed Nasser. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

public protocol SpinWheelDelegate: NSObjectProtocol {
	func wheelDidChangeValue(_ newValue: Int)
}

public protocol SpinWheelDataSource: NSObjectProtocol {
	func numberOfSections() -> Int
	func itemsForSections() -> [WheelItem]
}

public final class Wheel: UIView {
	public var delegate: SpinWheelDelegate?
	public var dataSource: SpinWheelDataSource? {
		didSet {
			reloadData()
		}
	}
	public var animateLanding = false
	public var aCircleTime: Double = 1.5
	
	var container = UIView()

	var timer: Timer?
	var isAnimating = false
	var selectedSectionIndex: Int = 0
	var landingPosition: LandingPostion = .top

	var angleSize: CGFloat {
		guard let dataSource = dataSource else {
			return 0
		}
		return CGFloat(360.0 / Double(dataSource.numberOfSections()))
	}
	
	var radius: CGFloat
	
	public init(radius: CGFloat) {
		self.radius = radius
		super.init(frame: CGRect(x: 0, y: 0, width: radius*2, height: radius*2))
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public func reloadData() {
		drawWheel()
	}
	
	public func setTarget(section: Int){
		assert(section <= (dataSource?.numberOfSections())!, "selected Section is out of bounds")
		self.selectedSectionIndex = section
	}
	
	public func start(completion: (() -> Void)? = nil) {
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

		self.layer.add(rotationAnimation, forKey: nil)
		if animateLanding {
			let selectedSection = self.container.layer.sublayers?.first(where: { $0.name == String(self.dataSource!.self.itemsForSections()[self.selectedSectionIndex].id) })
			let animation = CABasicAnimation(keyPath: "position")
			animation.fromValue = CGPoint(x: 0, y: 0)
			animation.toValue = CGPoint(x: 100, y: 100)
			animation.duration = 1.0
			animation.repeatCount = .infinity
			selectedSection!.add(animation, forKey: "positionAnimation")
		}
		CATransaction.commit()
		delegate?.wheelDidChangeValue(self.selectedSectionIndex)
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
		guard let dataSource = dataSource else { fatalError("nil data source") }
		assert((dataSource.numberOfSections()) == (dataSource.itemsForSections().count), "number of sections must be equal as items")
		let landingPostion: LandingPostion = .top
		container.removeFromSuperview()
		container = UIView()

		var start: CGFloat = CGFloat(landingPostion.rawValue) - angleSize/2
		var end: CGFloat = CGFloat(landingPostion.rawValue) + angleSize/2
		var angles: Array<CGFloat> = []
		
		for index in 0 ..< dataSource.numberOfSections() {
			angles.append(angleToRadian(start) + angleToRadian(angleSize)/2) // place text in the middle of every single pizza
			let shapeLayer = createShapeLayer(start: start, end: end, item: dataSource.itemsForSections()[index])
			container.layer.addSublayer(shapeLayer)
			start = CGFloat(fmodf(Float(start + angleSize), 360.0))
			end = CGFloat(fmodf(Float(end + angleSize), 360.0))
		}
		let labelsView = WheelItemText(angles: angles, withRadius: Float(radius), items: (dataSource.itemsForSections()))

		labelsView.frame = self.bounds
		container.frame = self.bounds
		addSubview(container)
		container.addSubview(labelsView)
	}

	private func createShapeLayer(start: CGFloat, end: CGFloat, item: WheelItem) -> CAShapeLayer {
		let path = UIBezierPath()
		let center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
		path.move(to: center)
		path.addArc(withCenter: center, radius: radius, startAngle: angleToRadian(start), endAngle: angleToRadian(end), clockwise: true)
		
		let layer = CAShapeLayer()
		layer.path = path.cgPath
		layer.fillColor = item.itemColor.cgColor
		layer.name = item.id
		return layer
	}
}

// MARK: - Helper
private extension Wheel {
	private func angleToRadian(_ angle: CGFloat) -> CGFloat {
		angle * .pi / 180.0
	}
}
