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

@objc protocol  SpinWheelDelegate: NSObjectProtocol {
	func wheelDidChangeValue(_ newValue: Int)
	@objc optional func lastAnimation() -> CABasicAnimation
	@objc optional func landingPostion() -> SpinWheel.LandingPostion
}

protocol SpinWheelDataSource: NSObjectProtocol {
	func numberOfSections() -> Int
	func itemsForSections() -> [WheelItem]
}

class SpinWheel: UIView {
	var delegate: SpinWheelDelegate?
	var dataSource :SpinWheelDataSource?
	var infinteRotation = false
	var animateLanding = false
	
	var container = UIView()
	
	var isAnimating = true
	var selectedSection: CALayer?
	var selectdSection: Int = 0
	
	var angleSize: CGFloat {
		guard let dataSource = dataSource else {
			return 0
		}
		return CGFloat(360.0 / Double(dataSource.numberOfSections()))
	}
	
	var wheelRadius: CGFloat {
		return self.frame.width / 2
	}
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		self.isUserInteractionEnabled = false
		self.isOpaque = false
		
		container = UIView(frame: frame)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func reloadData() {
		try? drawWheel()
	}
	
	func setTarget(section: Int){
		assert(section <= (dataSource?.numberOfSections())!, "selected Section is out of bounds")
		self.selectdSection = section
	}
	
	func manualRotation(aCircleTime: Double) {
		self.isAnimating = true
		UIView.animate(withDuration: aCircleTime, delay: 0.0, options: .curveEaseInOut, animations: {
			self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
		}, completion: { finished in
			UIView.animate(withDuration: aCircleTime, delay: 0.0, options: .curveEaseInOut, animations: {
				self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
			}, completion: { finished in
				if self.isAnimating {
					self.manualRotation(aCircleTime: aCircleTime)
				}
			})
		})
	}
	
	func stop() {
		self.isUserInteractionEnabled = false
		
		if isAnimating {
			isAnimating = false
			let zKeyPath = "layer.presentationLayer.transform.rotation.z"
			let currentRotation = (self.value(forKeyPath: zKeyPath) as? NSNumber)?.floatValue ?? 0.0
			let toArrow = (angleSize * (CGFloat(selectdSection) + 0.5))
			let rotationAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
			rotationAnimation.values = [currentRotation, torad(toArrow) + 2 * .pi ]
			rotationAnimation.keyTimes = [0, 1]
			rotationAnimation.duration = CFTimeInterval(1)
			rotationAnimation.fillMode = CAMediaTimingFillMode.forwards
			rotationAnimation.isRemovedOnCompletion = false
			layer.add(rotationAnimation, forKey: nil)
			rotationAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
			self.getSelectedSector(selectdSection)
		}
	}
}

extension SpinWheel {
	@objc
	enum LandingPostion:Int {
		case top = 270
		case left = 180
		case right = 360
		case bottom = 90
	}
}
// MARK: - Graphic
extension SpinWheel {
	private func drawWheel() throws {
		guard let dataSource = dataSource else {
			throw SpinWheelError.nilDataSource
		}
		assert((dataSource.numberOfSections()) == (dataSource.itemsForSections().count), "number of sections must be equal as items")
		let landingPostion = delegate?.landingPostion?() ?? .top
		
		var start: CGFloat = CGFloat(landingPostion.rawValue)
		var end: CGFloat = CGFloat(landingPostion.rawValue) + angleSize
		var angles: Array<CGFloat> = [] // for SpinWheelText rotateAngle
		
		for index in 0 ..< dataSource.numberOfSections() {
			angles.append(torad(start) + torad(angleSize)/2) // place text in the middle of every single pizza
			
			drawPizzaOnContainer(index, start: start, end: end, color: dataSource.itemsForSections()[index].itemColor)
			start += angleSize
			end += angleSize
			start = CGFloat(fmodf(Float(start), 360.0))
			end = CGFloat(fmodf(Float(end), 360.0))
		}
		
		container.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
		addSubview(container)
		
		drawLabelView(textRotateAngles: angles)
	}
	
	private func drawPizzaOnContainer(_ index: Int, start: CGFloat, end: CGFloat, color: UIColor?) {
		let path = UIBezierPath()
		let center = CGPoint(x: frame.size.width / 2, y: 0)
		path.move(to: center)
		path.addArc(withCenter: center, radius: wheelRadius, startAngle: torad(start), endAngle: torad(end), clockwise: true)
		
		let layer = CAShapeLayer()
		layer.path = path.cgPath
		layer.fillColor = color?.cgColor
		layer.name = "\(index+1)" // 為了在最後停止轉動時找到目標區塊
		container.layer.addSublayer(layer)
	}
	
	private func drawLabelView(textRotateAngles: Array<CGFloat>) {
		let labelsView = SpinWheelItemText(angles: textRotateAngles, withRadius: Float(wheelRadius), items: (dataSource?.itemsForSections())!)
		container.addSubview(labelsView)
		labelsView.fit(inView: self)
	}
}
// MARK: - Helpers
extension SpinWheel {
	private func torad(_ angle: CGFloat) -> CGFloat {
		return angle * .pi / 180.0
	}
	
	private func getSelectedSector(_ section: Int) {
		selectedSection = getSectorByValue(section)
		selectedSection!.opacity = Float(1)
		if let lastAnimation = delegate?.lastAnimation?() {
			selectedSection!.add(lastAnimation, forKey: "lastAnimation")
		} else {
			if animateLanding {
				let flash = CABasicAnimation(keyPath: "opacity")
				flash.fromValue = 0.8
				flash.toValue = 1
				flash.duration = 0.2
				flash.autoreverses = true
				flash.repeatCount = 2
				selectedSection!.add(flash, forKey: "flashAnimation")
			}
		}
		delegate!.wheelDidChangeValue(section)
	}
	
	private func getSectorByValue(_ value: Int) -> CALayer? {
		var res: CALayer?
		let views = container.layer.sublayers
		for im: CALayer in views ?? [] {
			if (im.name == "\(value)") {
				res = im
				break
			}
		}
		return res
	}
}

extension SpinWheel {
	enum SpinWheelError: Error {
		case nilDataSource
	}
}
