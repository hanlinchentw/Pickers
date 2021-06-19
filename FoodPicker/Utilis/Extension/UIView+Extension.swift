//
//  UIView+Extension.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/1.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit


extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingRight: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                width: CGFloat? = nil,
                height:CGFloat? = nil){
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    func setDimension(width: CGFloat, height:CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func centerX(inView view: UIView, xConstant : CGFloat = 0){
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: xConstant).isActive = true
    }
    func centerY(inView view: UIView, yConstant : CGFloat = 0){
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant).isActive = true
    }
    func center(inView view: UIView, xConstant : CGFloat = 0, yConstant : CGFloat = 0){
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant).isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: xConstant).isActive = true
    }
    func fit(inView view: UIView){
        anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
    }
    func widthMutiplier(widthAnchor: NSLayoutDimension, widthMultiplier: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalTo: widthAnchor, multiplier: widthMultiplier).isActive = true

    }
    func heightMultiplier(heightAnchor: NSLayoutDimension, heightMultiplier: CGFloat = 0 ) {
        translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightMultiplier).isActive = true
    }
    
    func createInputView(withTitle title: String, textField : UITextField) -> UIView {
        let view = UIView()
        let label = UILabel()
        label.font = UIFont(name: "ArialMT", size: 14)
        label.text = title
        
        view.addSubview(label)
        label.anchor(top: view.topAnchor, left: view.leftAnchor, paddingLeft: 8,height: 20)
        view.addSubview(textField)
        textField.layer.borderColor = UIColor.butterscotch.cgColor
        textField.anchor(top: label.bottomAnchor, left: view.leftAnchor,
                         right: view.rightAnchor,bottom: view.bottomAnchor, paddingTop: 4, height: 48)
        return view
    }
    
    func createFilterButton(text: String)-> UIView{
        let view = UIView()
        view.backgroundColor = UIColor(white: 220 / 255, alpha: 1)
        view.layer.cornerRadius = 20

        let textLabel = UILabel()
        textLabel.text = text
        textLabel.font = UIFont(name: "Arial-BoldMT", size: 14)
        textLabel.textColor = .customblack
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icnArrowDropDown")?.withRenderingMode(.alwaysOriginal)
        
        let stack = UIStackView(arrangedSubviews: [textLabel, imageView])
        stack.axis = .horizontal
        stack.spacing = 4
        view.addSubview(stack)
        stack.center(inView: view)
        
        return view
    }


}
