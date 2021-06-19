//
//  IntroView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/16.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

protocol IntroViewDelegate : AnyObject {
    func didTapCreateButton()
}

class IntroView : UIView {
    //MARK: - Properties
    weak var delegate : IntroViewDelegate?
    private let logoImageView : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logoY")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private let sloganLabel : UILabel = {
        let label = UILabel()
        label.text = "Pick for you, help you choose"
        label.font = UIFont(name: "Arial-BoldMT", size: 16)
        label.textColor = .gray
        return label
    }()
    private lazy var facebookButton : UIView = {
        let view = createAccountButton(withText: "Start with facebook",
                                                backgroundColor: .denimBlue,
                                                textColor : .white,
                                                imageName : "icnFbXs")
        return view
    }()
    private lazy var emailButton  :UIView = {
        let view = createAccountButton(withText: "Start with Email",
                                                backgroundColor: .white,
                                                textColor : .customblack,
                                                imageName:"icnMailXs")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(startWithEmailAuth))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = .white
        addSubview(logoImageView)
        logoImageView.center(inView: self, xConstant: 0, yConstant: -201)
        logoImageView.anchor(width: 120, height: 120)
        
        addSubview(sloganLabel)
        sloganLabel.centerX(inView: self)
        sloganLabel.anchor(top: logoImageView.bottomAnchor)
        
        let buttonstack = UIStackView(arrangedSubviews: [facebookButton, emailButton])
        buttonstack.axis = .vertical
        buttonstack.spacing = 16
        buttonstack.distribution = .fillEqually
        addSubview(buttonstack)
        buttonstack.center(inView: self, xConstant: 0, yConstant: 201)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
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
    
    //MARK: - Selectors
    @objc func startWithEmailAuth(){
        delegate?.didTapCreateButton()
    }
}
