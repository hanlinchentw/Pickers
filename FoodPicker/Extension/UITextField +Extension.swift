//
//  UITextField +Extension.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/1.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit
import Combine

extension UITextField {
    
    var textPublisher: AnyPublisher<String?, Never> {
        let publisher = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as? UITextField)}
            .filter {$0 == self}
            .map {$0.text}
            .eraseToAnyPublisher()
        return publisher
    }
    
    func inputTextField(isSecured : Bool) -> UITextField {
        let tf = UITextField()
        tf.textColor = .customblack
        tf.backgroundColor = .white
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 8
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        tf.leftViewMode = .always
        tf.isSecureTextEntry = isSecured
        tf.font = UIFont(name: "ArialMT", size: 16)
        return tf
    }
    
    func createSearchBar(withPlaceholder placeholder: String) -> UITextField {
        let iv = UIImageView()
        iv.image = UIImage(named: "icnSearchSmall")
        iv.contentMode = .scaleAspectFill
        
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 12
        tf.layer.masksToBounds = true
        tf.leftView = iv
        tf.leftViewMode = .always
        tf.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                      attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        tf.placeholder = placeholder
        return tf
    }
    

}
