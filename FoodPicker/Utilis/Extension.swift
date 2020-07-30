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
    
    func createInputView(withTitle title: String, textField : UITextField) -> UIView {
        let view = UIView()
        let label = UILabel()
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        label.font = UIFont(name: "Avenir-Book", size: 14)
        label.text = title
        
        view.addSubview(label)
        label.anchor(top: view.topAnchor, left: view.leftAnchor,height: 30)
        view.addSubview(textField)
        textField.anchor(top: label.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,bottom: view.bottomAnchor, height: 50)
        return view
    }
    
    func createFilterButtonView(text: String)-> UIView{
        let view = UIView()
        let imageView = UIImageView()
        view.heightAnchor.constraint(equalToConstant: 48).isActive = true
        imageView.image = UIImage(named: "icnOval")
        view.addSubview(imageView)
        imageView.anchor(top:view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor)
        
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.font = UIFont(name: "Avenir-Book", size: 14)
        textLabel.textColor = .white
        view.addSubview(textLabel)
        textLabel.anchor(top:view.topAnchor, left: imageView.rightAnchor,right: view.rightAnchor, bottom: view.bottomAnchor)
        return view
    }
}

extension UITextField {
    func inputTextField(isSecured : Bool) -> UITextField {
        let tf = UITextField()
        tf.textColor = .black
        tf.backgroundColor = .white
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 8
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        tf.leftViewMode = .always
        tf.isSecureTextEntry = isSecured
        return tf
    }
}
extension UIButton {
    func createAccountButton(withText text : String) -> UIButton{
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1
        button.anchor(width : 300, height : 50)
        return button
    }
    
    
}
extension UIColor {
    
    @nonobjc class var backgroundColor: UIColor {
        return UIColor(white: 230 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var veryLightPinkTwo: UIColor {
        return UIColor(white: 216.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var black: UIColor {
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
