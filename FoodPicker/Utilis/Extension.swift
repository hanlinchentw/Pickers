//
//  Extension.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import MapKit

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
    func createPasswordRequirementView(imageView : UIImageView, label: UILabel) -> UIView{
        let view = UIView()
        view.setDimension(width: 300, height: 16)
        imageView.image = UIImage(named: "icnDotXs")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.anchor(top:view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
                         width: 16, height: 16)
        label.font = UIFont(name: "ArialMT", size: 14)
        label.textColor = .gray
        view.addSubview(label)
        label.anchor(top:view.topAnchor, left: imageView.rightAnchor,
                     right: view.rightAnchor, bottom: view.bottomAnchor, paddingLeft: 8)
        return view
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
        textField.anchor(top: label.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,bottom: view.bottomAnchor, paddingTop: 4, height: 48)
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
    
    func createAccountButton(withText text : String, backgroundColor : UIColor,textColor : UIColor,  imageName : String) -> UIView{
        let view = UIView()
        let imageView = UIImageView()
        view.backgroundColor = backgroundColor
        view.setDimension(width: 304, height: 48)
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.anchor(left: view.leftAnchor, paddingLeft: 14, width: 24, height: 24)
        imageView.centerY(inView: view)
        
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.font = UIFont(name: "Arial-BoldMT", size: 16)
        textLabel.textColor = textColor
        textLabel.textAlignment = .center
        view.addSubview(textLabel)
        textLabel.anchor(top:view.topAnchor, left: imageView.rightAnchor,
                         right: view.rightAnchor, bottom: view.bottomAnchor,
                         paddingLeft: 10, paddingRight: 32)

        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        return view
    }
}
extension UIButton {
    func createViewWithRoundedCornerAndShadow(withText text: String? = nil, imageName : String? = nil) -> UIButton{
        let button = UIButton(type: .system)
        if let imageName = imageName {
            button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
        }else{
            button.setTitle(text, for: .normal)
            button.titleLabel?.font = UIFont(name: "Arial-BoldMT", size: 14)
            button.tintColor = .customblack
            button.backgroundColor = .clear
        }
        button.isHidden = true
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.customblack.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 5
        
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        
        button.insertSubview(view, at: 0)
        view.fit(inView: button)
        
        return button
    }
    
}

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

extension UIFont {
    class var arialMT: UIFont {
        return UIFont(name: "ArialMT", size: 14) ?? UIFont()
    }
    class var arialBoldMT: UIFont {
        return UIFont(name: "Arial-BoldMT", size: 16) ?? UIFont()
    }
}
extension UIColor {
    @nonobjc class var denimBlue: UIColor {
      return UIColor(red: 60.0 / 255.0, green: 89.0 / 255.0, blue: 157.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var backgroundColor: UIColor {
        return UIColor(white: 238 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var veryLightPinkTwo: UIColor {
        return UIColor(white: 216.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var customblack: UIColor {
        return UIColor(white: 51.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var butterscotch: UIColor {
        return UIColor(red: 1.0, green: 192.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var freshGreen: UIColor {
        return UIColor(red: 127.0 / 255.0, green: 203.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var pale: UIColor {
        return UIColor(red: 1.0, green: 238.0 / 255.0, blue: 207.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var gray: UIColor {
      return UIColor(white: 151.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var errorRed: UIColor {
      return UIColor(red: 231.0 / 255.0, green: 102.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var lightlightGray: UIColor {
       return UIColor(white: 238.0 / 255.0, alpha: 1.0)
     }
    
}
extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 92
        return sizeThatFits
    }
}
extension UISearchBar {
    func changeSearchBarColor(color: UIColor) {
        UIGraphicsBeginImageContext(self.frame.size)
        color.setFill()
        UIBezierPath(rect: self.frame).fill()
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.setSearchFieldBackgroundImage(bgImage, for: .normal)
    }
}
extension MKMapView {
    func fitAll() {
        var zoomRect  = MKMapRect.null;
        for annotation in annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect       = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01);
            zoomRect            = zoomRect.union(pointRect);
        }
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
    }
}
