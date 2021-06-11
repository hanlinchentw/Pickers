//
//  UITextField +Extension.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/1.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit


extension UITextField {
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
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 12
        tf.layer.masksToBounds = true
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        tf.leftViewMode = .always
        tf.placeholder = placeholder

        let iv = UIImageView()
        iv.image = UIImage(named: "icnSearchSmall")
        iv.contentMode = .scaleAspectFill
        tf.addSubview(iv)
        iv.centerY(inView:tf)
        iv.anchor(left:tf.leftAnchor, paddingLeft: 8,width: 24 ,height: 24)
        return tf
    }
    

}
