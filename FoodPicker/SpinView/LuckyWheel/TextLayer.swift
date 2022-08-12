//
//  TextLayer.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/2/21.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit

class TextLayer: NSObject{
    @objc func drawTextLayer(text strd: String, context: CGContext, radius r: CGFloat,
                             angle theta: CGFloat, colour c: UIColor, font: UIFont, containsChinese: Bool){
        
        let spacing : CGFloat = containsChinese ? 1.5 : 0.5
        centre(text: strd, context: context, radius: r, colour: c, font: font, spacing:  spacing, angle: theta)
    }
    func centre(text str: String, context: CGContext, radius r: CGFloat, colour c: UIColor, font: UIFont, spacing: CGFloat,angle: CGFloat) {
        // Set the text attributes
        let attributes = [NSAttributedString.Key.foregroundColor: c, NSAttributedString.Key.font: font, NSAttributedString.Key.kern: spacing] as [NSAttributedString.Key : Any]

        context.saveGState()
        let offset = str.size(withAttributes: attributes)
        context.rotate(by: angle)
        context.scaleBy(x: -1, y: 1)
        context.translateBy (x: r/2.5, y: -offset.height/2)
        str.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        context.restoreGState()
    }
    
}
