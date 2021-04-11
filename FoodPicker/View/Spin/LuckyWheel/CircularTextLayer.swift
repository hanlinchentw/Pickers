//
//  CircularLabel.swift
//  wheel
//
//  Created by Ahmed Nasser on 12/25/18.
//  Copyright © 2018 Ahmed Nasser. All rights reserved.
//

import Foundation
import UIKit

@objc
class CircularTextLayer :NSObject {
    var lineLength :CGFloat = 0.0
    var offsets :CGFloat = 0.0
    var currentOffset :CGFloat = 0
    var potintialOffset :CGFloat = 0
    var offsetsY = [CGFloat]()
    var cutPoints = [Int]()
    var attributes:[NSAttributedString.Key : NSObject]?
    @objc
    func centreArcPerpendicular(text strd: String, context: CGContext, radius r: CGFloat, angle theta: CGFloat, colour c: UIColor, font: UIFont, clockwise: Bool, numOfSections:Int){
        // *******************************************************
        // This draws the String str around an arc of radius r,
        // with the text centred at polar angle theta
        // *******************************************************
        offsets = 0.0
        currentOffset = 0
        offsetsY = [CGFloat]()
        cutPoints = [Int]()
        
        var characters: [String] = strd.map { String($0) } // An array of single character strings, each character in str
        var l = characters.count
        l = characters.count
        attributes = [NSAttributedString.Key.foregroundColor: c, NSAttributedString.Key.font: font]
        
        
        // Are we writing clockwise (right way up at 12 o'clock, upside down at 6 o'clock)
        // or anti-clockwise (right way up at 6 o'clock)?
        let direction: CGFloat = clockwise ? -1 : 1
        let slantCorrection: CGFloat = clockwise ? -.pi / 2 : .pi / 2
        
        // The centre of the first character will then be at
        // thetaI = theta - totalArc / 2 + arcs[0] / 2
        // But we add the last term inside the loop
        var thetaI =  theta - direction * (lineLength - 0.1) / 2
        offsetsY.append(currentOffset)
        spearteInLines(characters: characters)
        offsetsY = offsetsY.reversed()
        offsets = 0
        currentOffset = (potintialOffset != 0 && offsetsY.count == 1) ? potintialOffset : offsetsY[0]
        var line = 0
        for i in 0 ..< l {
            if cutPoints.contains(i) {
                // new line
                thetaI =  theta - direction * (lineLength - 0.1) / 2
                offsets = 0
                line += 1
                potintialOffset = offsetsY[0]
                currentOffset = offsetsY[line]
            }
           
            let correction: CGFloat = i%2 == 0 ? -1 : 1
            // Call centerText with each character in turn.
            // Remember to add +/-90º to the slantAngle otherwise
            // the characters will "stack" round the arc rather than "text flow"
            centre(text: characters[i], context: context, radius: r, angle: thetaI, colour: c, font: font, numOfChars: CGFloat(i), correction: correction)
            // The centre of the next character will then be at
    
            // but again we leave the last term to the start of the next loop...

        }
    }
    func spearteInLines(characters: [String]) {
        for i in 0 ..< characters.count  {

            if offsets >= lineLength - 0.1 {
                offsets = 0
                let offset = characters[i].size(withAttributes: attributes)
                currentOffset -=  offset.height + 6
                offsetsY.append(currentOffset)
                if characters[i] != " " {
                    //word wrap
                    for j in stride(from: i, to: 0, by: -1) {
                        if characters[j] == " " {
                            cutPoints.append(j+1)
                            break
                        }
                    }
                }else{
                    cutPoints.append(i)
                }
            }
        }
    }

    func centre(text str: String, context: CGContext, radius r: CGFloat, angle theta: CGFloat, colour c: UIColor, font: UIFont, numOfChars: CGFloat, correction: CGFloat) {
        // *******************************************************
        // This draws the String str centred at the position
        // specified by the polar coordinates (r, theta)
        // i.e. the x= r * cos(theta) y= r * sin(theta)
        // and rotated by the angle slantAngle
        // *******************************************************
        
        // Set the text attributes
        let attributes = [NSAttributedString.Key.foregroundColor: c, NSAttributedString.Key.font: font]
        //let attributes = [NSForegroundColorAttributeName: c, NSFontAttributeName: font]
        // Save the context
        context.saveGState()
        // Undo the inversion of the Y-axis (or the text goes backwards!)
        context.scaleBy(x: 1, y: correction*1)
        // Move the origin to the centre of the text (negating the y-axis manually)
        context.translateBy(x: 0.15*r * cos(theta), y: -numOfChars*0.15*(r * sin(theta)))
        // Calculate the width of the text
        let offset = str.size(withAttributes: attributes)
        // Move the origin by half the size of the text
        context.translateBy (x: -offset.width / 2, y: currentOffset) // Move the origin to the centre of the text (negating the y-axis manually)
        // Draw the text
        str.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        // Restore the context
        context.restoreGState()
    }
}
extension StringProtocol where Index == String.Index {
    func encodedOffset(of element: Element) -> Int? {
        return firstIndex(of: element)?.encodedOffset
    }
    func encodedOffset(of string: Self) -> Int? {
        return range(of: string)?.lowerBound.encodedOffset
    }
    
}
