//
//  FilterView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/27.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

protocol FilterViewDelegate : AnyObject  {
    func didTapSortButton()
    func didTapPriceButton()
}

class FilterView : UIView {
    //MARK: - Properties
    weak var delegate : FilterViewDelegate?
    
    public var sortOptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Sort: Nearby"
        label.font = UIFont(name: "Arial-BoldMT", size: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var sortButton : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 220 / 255, alpha: 1)
        view.layer.cornerRadius = 20
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icnArrowDropDown")?.withRenderingMode(.alwaysOriginal)
        imageView.setDimension(width: 30, height: 30)
        
        let stack = UIStackView(arrangedSubviews: [sortOptionLabel, imageView])
        stack.axis = .horizontal
        stack.spacing = 2
        view.addSubview(stack)
        stack.fit(inView: view)
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
        let sortButtonWidth = 147 * widthMultiplier
        sortButton.anchor(left: leftAnchor, paddingLeft: 16,  width: sortButtonWidth, height: 40)
        sortButton.centerY(inView: self)
        addSubview(priceRangeButton)
        let priceRangeButtonWidth = 147 * widthMultiplier
        priceRangeButton.anchor(left: sortButton.rightAnchor, paddingLeft: 8,width: priceRangeButtonWidth, height: 40)
        priceRangeButton.centerY(inView: self)
    }
    func configureSortOptionText(text: String){
        self.sortOptionLabel.text = "Sort: \(text)"
    }
    //MARK: - Selectors
    @objc func handleSortButtonTapped(){
        delegate?.didTapSortButton()
    }
    @objc func handlePriceButtonTapped(){
        delegate?.didTapPriceButton()
    }
}


