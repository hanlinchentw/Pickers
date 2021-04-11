//
//  LuckyWheelWheelText.swift
//  LuckyWheel
//
//  Created by Ahmed Nasser on 12/26/18.
//  Copyright © 2018 Ahmed Nasser. All rights reserved.
//

import UIKit

class LuckyWheelText: UIView {
    var angles: [CGFloat] = []
    var wheelRadius: Float = 0.0
    var items = [WheelItem]()
    func setAngles(_ angles: [CGFloat], withRadius wheelRadius: Float, items:[WheelItem]) {
        self.angles = angles
        self.wheelRadius = wheelRadius
        self.items = items
        setNeedsDisplay()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = true
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        
        let size: CGSize = bounds.size
        context?.translateBy(x: size.width/2, y: size.height/2)
        context?.scaleBy(x: 1, y: -1)
        
        let text = TextLayer()
        var i = 0
        for angle in angles {
            let a = CGFloat(angle)
            
            guard var name = items[i].title else { return }
            var numOfChars = name.count
            let nameContainsChinese = name.containsChineseCharacters
            let charOffset = nameContainsChinese ? 12 : 4
            while (Int(wheelRadius)/2) <= numOfChars * charOffset{
                name = String(name.dropLast())
                numOfChars -= 1
                if (Int(wheelRadius)/2) > numOfChars * charOffset{
                    name = String(name.dropLast())
                    name.append("...")
                }
            }
            text.drawTextLayer(text: name, context: context!, radius: CGFloat(wheelRadius - 15), angle: a,colour:  items[i].titleColor ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), font: UIFont(name: "Arial-BoldMT", size: 14)!, containsChinese: nameContainsChinese)
            i += 1
        }
    }
    
}
