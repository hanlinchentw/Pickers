//
//  String+Extensions.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/14.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit

extension String {
    
    var containsChineseCharacters: Bool {
        return self.range(of: "\\p{Han}", options: .regularExpression) != nil
    }
    
    var attributedStringWithBullet: NSAttributedString {
        let imageAttachment = NSTextAttachment()
        let image = UIImage(named: "icnDotXs")?.withRenderingMode(.alwaysOriginal)
        imageAttachment.image = image
        // Set bound to reposition
        imageAttachment.bounds = CGRect(x: 0, y: -3, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        // Create string with attachment
        let content = NSMutableAttributedString(string: "")
        content.append(NSAttributedString(attachment: imageAttachment))
        content.append(NSAttributedString(string: self))
        return content
    }
    
    var attributedStringWithCheckmark: NSAttributedString {
        let imageAttachment = NSTextAttachment()
        let image = UIImage(named: "icnAvailableXs")?.withRenderingMode(.alwaysOriginal)
        imageAttachment.image = image
        // Set bound to reposition
        imageAttachment.bounds = CGRect(x: 0, y: -3, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        // Create string with attachment
        let content = NSMutableAttributedString(string: "")
        content.append(NSAttributedString(attachment: imageAttachment))
        content.append(NSAttributedString(string: self))
        return content
    }
}
