//
//  IntroView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/16.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

protocol IntroViewDelegate : class {
    func didTapCreateButton()
}

class IntroView : UIView {
    //MARK: - Properties
    weak var delegate : IntroViewDelegate?
    private let facebookButton  :UIButton = {
        let button = UIButton().createAccountButton(withText: "Start with facebook")
        button.rx.tap.bind{
            
        }.dispose()
        return button
    }()
    private lazy var googleButton  :UIButton = {
        let button = UIButton().createAccountButton(withText: "Start with google")
        button.rx.tap.bind{
            
        }.dispose()
        return button
    }()
    private lazy var emailButton  :UIButton = {
        let button = UIButton().createAccountButton(withText: "Start with Email")
        button.rx.tap.bind{
            self.delegate?.didTapCreateButton()
        }.dispose()
        return button
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = .white
        
        let buttonstack = UIStackView(arrangedSubviews: [facebookButton, googleButton, emailButton])
        buttonstack.axis = .vertical
        buttonstack.spacing = 8
        buttonstack.distribution = .fillEqually
        addSubview(buttonstack)
        buttonstack.centerX(inView: self)
        buttonstack.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    
    //MARK: - Selectors
}
