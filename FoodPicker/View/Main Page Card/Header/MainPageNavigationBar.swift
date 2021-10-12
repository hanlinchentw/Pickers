//
//  MainPageHeader.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/6.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit


protocol MainPageHeaderDelegate : AnyObject {
    func handleHeaderGotTapped()
}

class MainPageNavigationBar : UIView {
    //MARK: - Properties
    private var shouldShowMapView = false
    
    weak var delegate : MainPageHeaderDelegate?

    private lazy var listModeButton : UIButton = {
        return createModeButton(withTitle: "List")
    }()
    private lazy var mapModeButton : UIButton = {
        return createModeButton(withTitle: "Map")
    }()
    private let blackDot : UIView = {
        let view = UIView()
        view.backgroundColor = .customblack
        view.heightAnchor.constraint(equalToConstant: 5).isActive = true
        view.widthAnchor.constraint(equalToConstant: 5).isActive = true
        view.layer.cornerRadius = 5 / 2
        return view
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 36
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.masksToBounds = true

        let navItemStack = UIStackView(arrangedSubviews: [listModeButton, mapModeButton])
        navItemStack.axis = .horizontal
        navItemStack.distribution = .fillEqually
        navItemStack.alignment = .bottom
        
        addSubview(navItemStack)
        navItemStack.anchor(top: topAnchor, left: leftAnchor,
                            right: rightAnchor, bottom: bottomAnchor, paddingBottom: 16)
        
        addSubview(blackDot)
        blackDot.centerX(inView: listModeButton)
        blackDot.anchor(bottom: bottomAnchor, paddingBottom: 12)
        
        listModeButton.titleEdgeInsets = UIEdgeInsets(top: listModeButton.frame.height/2, left: 0, bottom: 0, right: 0)
        mapModeButton.titleEdgeInsets = UIEdgeInsets(top: mapModeButton.frame.height/2, left: 0, bottom: 0, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    fileprivate func createModeButton(withTitle title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial-BoldMT", size: 16)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(switchMode), for: .touchUpInside)
        return button
    }
    //MARK: - Selectors
    @objc func switchMode(){
        shouldShowMapView.toggle()
        let labelDistance = mapModeButton.frame.minX - listModeButton.frame.minX
        if shouldShowMapView {
            self.blackDot.frame.origin.x += labelDistance
            self.listModeButton.isUserInteractionEnabled = true
            self.mapModeButton.isUserInteractionEnabled = false
        }else{
            self.blackDot.frame.origin.x -= labelDistance
            self.listModeButton.isUserInteractionEnabled = false
            self.mapModeButton.isUserInteractionEnabled = true
        }
        self.delegate?.handleHeaderGotTapped()
    }
}

