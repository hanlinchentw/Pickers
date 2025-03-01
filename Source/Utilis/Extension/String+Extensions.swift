//
//  String+Extensions.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/14.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit

extension String {
  var toInt: Int? {
    Int(self)
  }

  var containsChineseCharacters: Bool {
    range(of: "\\p{Han}", options: .regularExpression) != nil
  }

  func attributedStringWithImage(_ uiImage: UIImage?) -> NSAttributedString {
    let imageAttachment = NSTextAttachment()
    imageAttachment.image = uiImage
    // Set bound to reposition
    imageAttachment.bounds = CGRect(x: 0, y: -3, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
    // Create string with attachment
    let content = NSMutableAttributedString(string: "")
    content.append(NSAttributedString(attachment: imageAttachment))
    content.append(NSAttributedString(string: self))
    return content
  }

  var attributedStringWithBullet: NSAttributedString {
    attributedStringWithImage(UIImage(named: "icnDotXs")?.withRenderingMode(.alwaysOriginal))
  }

  var attributedStringWithCheckmark: NSAttributedString {
    attributedStringWithImage(UIImage(named: "icnAvailableXs")?.withRenderingMode(.alwaysOriginal))
  }
}
