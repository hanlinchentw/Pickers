//
//  UIButton+ Extension.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/1.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit

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
    func changeImageButtonWithBounceAnimation(changeTo imageName: String){
        let zoomAnimation = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCrossDissolve) {
            self.setImage(UIImage(named: imageName)?
                                .withRenderingMode(.alwaysOriginal), for: .normal)
            self.transform = zoomAnimation
        } completion: { (_) in
            UIView.animate(withDuration: 0.4, delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.2,
                           options: .curveEaseOut) {
                self.transform = zoomAnimation.inverted()
            }
        }
    }
}
