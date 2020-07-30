//
//  MainPageHeader.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/6.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol MainPageHeaderDelegate : class {
    func handleHeaderGotTapped()
}

class MainPageHeader : UIView {
    //MARK: - Properties
    private var shouldShowMapView = false
    
    weak var delegate : MainPageHeaderDelegate?
    private let labelDistance : CGFloat = 14 + 89 + 103.5
    private lazy var listLabel : UILabel = {
        let label = UILabel()
        label.text = "List"
        label.font = UIFont(name: "Avenir-Heavy", size: 14)
        label.textAlignment = .center
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(switchMode))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = false
        return label
    }()
    private lazy var mapLabel : UILabel = {
        let label = UILabel()
        label.text = "Map"
        label.font = UIFont(name: "Avenir-Heavy", size: 14)
        label.textAlignment = .center
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(switchMode))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    private let blackDot : UIView = {
        let view = UIView()
        view.backgroundColor = .black
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
        layer.masksToBounds = true
        
        let navItemStack = UIStackView(arrangedSubviews: [listLabel, mapLabel])
        navItemStack.axis = .horizontal
        navItemStack.distribution = .fillEqually
        
        addSubview(navItemStack)
        navItemStack.anchor(left:leftAnchor, right: rightAnchor, bottom: bottomAnchor,
                            paddingBottom: 16)
        
        addSubview(blackDot)
        blackDot.centerX(inView: listLabel)
        blackDot.anchor(bottom: bottomAnchor, paddingBottom: 11)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Selectors
    @objc func switchMode(){
        shouldShowMapView.toggle()
        if shouldShowMapView {
            self.blackDot.frame.origin.x += self.labelDistance
            self.listLabel.isUserInteractionEnabled = true
            self.mapLabel.isUserInteractionEnabled = false
            self.delegate?.handleHeaderGotTapped()
        }else{
            self.blackDot.frame.origin.x -= self.labelDistance
            self.listLabel.isUserInteractionEnabled = false
            self.mapLabel.isUserInteractionEnabled = true
            self.delegate?.handleHeaderGotTapped()
        }
    }
}

