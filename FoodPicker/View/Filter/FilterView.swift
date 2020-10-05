//
//  FilterView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/27.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

protocol FilterViewDelegate : class  {
    func didTapSortButton()
    func didTapPriceButton()
}



class FilterView : UIView {
    //MARK: - Properties
    weak var delegate : FilterViewDelegate?
    private lazy var sortButton : UIView = {
        let view = UIView().createFilterButton(text: "Sort: Popular ")
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleSortButtonTapped))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        return view
    }()
    private lazy var priceRangeButton : UIView = {
        let view = UIView().createFilterButton(text: "Price Range")
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePriceButtonTapped))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        return view
    }()
    private let openFilterButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Open", for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial-BoldMT", size: 14)
        button.layer.cornerRadius = 20
        button.tintColor = .customblack
        button.backgroundColor = UIColor(white: 220 / 255, alpha: 1)
        return button
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configure(){
        addSubview(sortButton)
        sortButton.anchor(left: leftAnchor, paddingLeft: 16,  width: 155, height: 40)
        sortButton.centerY(inView: self)
        addSubview(priceRangeButton)
        priceRangeButton.anchor(left: sortButton.rightAnchor, paddingLeft: 8,width: 147, height: 40)
        priceRangeButton.centerY(inView: self)
        addSubview(openFilterButton)
        openFilterButton.anchor(left: priceRangeButton.rightAnchor, paddingLeft: 8,width: 70, height: 40)
        openFilterButton.centerY(inView: self)
    }
    //MARK: - Selectors
    @objc func handleSortButtonTapped(){
        delegate?.didTapSortButton()
    }
    @objc func handlePriceButtonTapped(){
        delegate?.didTapPriceButton()
    }
}


