//
//  WheelItemText.swift
//  WheelUI
//
//  Created by 陳翰霖 on 2023/8/26.
//

import UIKit

class WheelItemText: UIView {
	private var angles: [CGFloat]
	private var wheelRadius: Float
	private var items: [WheelItem]

	init(angles: [CGFloat], withRadius wheelRadius: Float, items: [WheelItem]) {
		self.angles = angles
		self.wheelRadius = wheelRadius
		self.items = items
		super.init(frame: .zero)
		isOpaque = true
		backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func draw(_ rect: CGRect) {
		super.draw(rect)
		if (items.isEmpty) { return }
		let context = UIGraphicsGetCurrentContext()

		let size: CGSize = bounds.size
		context?.translateBy(x: size.width/2, y: size.height/2)
		context?.scaleBy(x: 1, y: -1)

		for (index, angle) in angles.enumerated() {
			var name = items[index].title
			var numOfChars = name.count
			let charOffset = 8

			while Int(wheelRadius / 2) <= numOfChars * charOffset {
				name = String(name.dropLast())
				numOfChars -= 1
				if Int(wheelRadius / 2) > numOfChars * charOffset {
					name.append("...")
				}
			}
			drawTextLayer(text: name, context: context!, angle: angle)
		}
	}
}

extension WheelItemText {
	func drawTextLayer(text: String, context: CGContext, angle: CGFloat){
		let textSpacing : CGFloat = 1
		// Set the text attributes
		let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
											NSAttributedString.Key.font: UIFont(name: "Arial-BoldMT", size: 14) as Any,
											NSAttributedString.Key.kern: textSpacing] as [NSAttributedString.Key : Any]

		context.saveGState()
		let offset = text.size(withAttributes: attributes)
		context.rotate(by: angle)
		context.scaleBy(x: -1, y: 1)
		context.translateBy (x: CGFloat(wheelRadius) / 3, y: -offset.height/2)
		text.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
		context.restoreGState()
	}
}
