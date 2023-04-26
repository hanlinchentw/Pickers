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
	public var aCircleTime: Double = 1
	
	var container = UIView()
	
	var timer: Timer?
	var isAnimating = true
	var selectedSectionIndex: Int = 0
	var landingPosition: LandingPostion = .top

	var angleSize: CGFloat {
		guard let dataSource = dataSource else {
			return 0
		}
		return CGFloat(360.0 / Double(dataSource.numberOfSections()))
	}
	
	var wheelRadius: CGFloat {
		self.frame.width / 2
	}
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		container = UIView(frame: frame)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	public func reloadData() {
		drawWheel()
	}
	
	public func setTarget(section: Int){
		assert(section <= (dataSource?.numberOfSections())!, "selected Section is out of bounds")
		self.selectedSectionIndex = section
	}
	
	public func rotate() {
		if isAnimating { return }
		timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
			self.isAnimating = true
			UIView.animate(withDuration: self.aCircleTime, delay: 0.0, options: .curveEaseInOut, animations: {
				self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
			}, completion: { _ in
				UIView.animate(withDuration: self.aCircleTime*2, delay: 0.0) {
					self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*2))
				}
			})
		}
	}
	
	public func stop() {
		timer?.invalidate()
		if isAnimating {
			isAnimating = false
			let zKeyPath = "layer.presentationLayer.transform.rotation.z"
			let currentRotation = (self.value(forKeyPath: zKeyPath) as? NSNumber)?.floatValue ?? 0.0
			let finalAngle = -angleToRadian(angleSize * CGFloat(selectedSectionIndex)) + (2 * .pi)
			let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
			rotationAnimation.toValue = finalAngle
			rotationAnimation.duration = aCircleTime*5 // 20% spinning speed
			rotationAnimation.isRemovedOnCompletion = false
			rotationAnimation.fillMode = .both
			rotationAnimation.timingFunction = .init(name: .easeInEaseOut)
			layer.add(rotationAnimation, forKey: nil)
			
			if animateLanding {
				let selectedSection = container.layer.sublayers?.first(where: { $0.name == String(dataSource!.itemsForSections()[selectedSectionIndex].id) })
				let animation = CABasicAnimation(keyPath: "position")
				animation.fromValue = CGPoint(x: 0, y: 0)
				animation.toValue = CGPoint(x: 100, y: 100)
				animation.duration = 1.0
				animation.repeatCount = .infinity
				selectedSection!.add(animation, forKey: "positionAnimation")
			}
			delegate!.wheelDidChangeValue(selectedSectionIndex)
		}
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
private extension Wheel {
	var textAttributes: [NSAttributedString.Key: Any] {
		let TEXT_SPACING = 1.2
		return [
			NSAttributedString.Key.foregroundColor: UIColor.black,
			NSAttributedString.Key.font: UIFont(name: "Arial-BoldMT", size: 14) as Any,
			NSAttributedString.Key.kern: TEXT_SPACING,
		] as [NSAttributedString.Key : Any]
	}
	
	private func drawWheel() {
		guard let dataSource = dataSource else {
			fatalError("Missing Wheel dataSource.")
		}
		assert((dataSource.numberOfSections()) == (dataSource.itemsForSections().count), "number of sections must be equal as items")
		container.layer.sublayers?.removeAll()
		
		let start = CGFloat(landingPosition.rawValue) - angleSize/2
		(0 ..< dataSource.numberOfSections())
			.map { index -> (CGFloat, CGFloat, WheelItem) in
				let startAngle = start + CGFloat(index)*angleSize
				let endAngle = startAngle + angleSize
				let item = dataSource.itemsForSections()[index]
				return (startAngle, endAngle, item)
			}
			.forEach { startAngle, endAngle, item in
				let shapeLayer = createShapeLayer(start: startAngle, end: endAngle, item: item)
				container.layer.addSublayer(shapeLayer)
				let textLayer = createTextLayer(start: startAngle, end: endAngle, item: item)
				container.layer.addSublayer(textLayer)
			}
		addSubview(container)
	}
	
	func createShapeLayer(start: CGFloat, end: CGFloat, item: WheelItem) -> CAShapeLayer {
		let path = UIBezierPath()
		let center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
		path.move(to: center)
		path.addArc(withCenter: center, radius: wheelRadius, startAngle: angleToRadian(start), endAngle: angleToRadian(end), clockwise: true)
		
		let layer = CAShapeLayer()
		layer.path = path.cgPath
		layer.fillColor = item.itemColor.cgColor
		layer.name = item.id
		return layer
	}
	
	func createTextLayer(start: CGFloat, end: CGFloat, item: WheelItem) -> CATextLayer {
		let textSize = item.title.size(withAttributes: textAttributes)
		let center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
		let textAngle = angleToRadian(start+angleSize/2)
		
		let startOnRadius = 0.4
		let p = pointOnCircle(center: center, radius: wheelRadius*startOnRadius, angle: textAngle)
		var textLayerframe = CGRect(x: 0, y: 0, width: wheelRadius*(1-startOnRadius)-16, height: textSize.height)
		textLayerframe.origin.x = p.x - (textLayerframe.size.width * 0.5)
		textLayerframe.origin.y = p.y - (textLayerframe.size.height * 0.5)
		
		let textLayer = CATextLayer()
		textLayer.frame = textLayerframe
		textLayer.anchorPoint = CGPoint(x: 0, y: 0.5)
		textLayer.transform = CATransform3DMakeRotation(textAngle, 0, 0, 1)
		textLayer.alignmentMode = .left
		textLayer.truncationMode = .end
		textLayer.string = NSAttributedString(string: item.title, attributes: textAttributes)
		return textLayer
	}
	
	func pointOnCircle(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
		let x = center.x + radius * cos(angle)
		let y = center.y + radius * sin(angle)
		return CGPoint(x: x, y: y)
	}

	private func angleToRadian(_ angle: CGFloat) -> CGFloat {
		angle * .pi / 180.0
	}
}
