//
//  FilterView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/27.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

protocol FilterViewDelegate : class  {
    func didSelectOption(_ filter : FilterOptions)
}

enum FilterOptions : Int, CaseIterable {
    case nearby = 0
    case popular
    case highestRate

    var description : String {
        switch self {
        case .nearby: return "Nearby"
        case .popular: return "Popular"
        case .highestRate: return "Highest Rated"
        }
    }
    
    var sortby : String {
        switch self {
        case .nearby: return "distance"
        case .highestRate: return "rating"
        case .popular: return "review_count"
        }
    }
}

class FilterView : UIView {
    //MARK: - Properties
    var options : [FilterOptions] = [] {
        didSet{
            configure()
        }
    }
    weak var delegate : FilterViewDelegate?
    private lazy var nearByFilterButton : CustomFilterButton = {
        let view = CustomFilterButton(option: .nearby)
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(handleNearbyFilterButtonTapped))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var popularFilterButton : CustomFilterButton = {
        let view = CustomFilterButton(option: .popular)
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(handlePopularFilterButtonTapped))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var highestRatedFilterButton : CustomFilterButton = {
        let view = CustomFilterButton(option: .highestRate)
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(handleHighestRatedFilterButtonTapped))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        return view
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = .black
        layer.cornerRadius = 16
        
        let stack = UIStackView(arrangedSubviews: [nearByFilterButton, popularFilterButton, highestRatedFilterButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .equalSpacing
        
        addSubview(stack)
        stack.center(inView: self)
        stack.anchor(left: leftAnchor, right:  rightAnchor, paddingLeft: 8, paddingRight: 8)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configure(){
        print("DEBUG: \(options)")
        nearByFilterButton.isSelected = options.contains(.nearby)
        popularFilterButton.isSelected = options.contains(.popular)
        highestRatedFilterButton.isSelected = options.contains(.highestRate)
    }
    //MARK: - Selectors
    @objc func handleNearbyFilterButtonTapped(){
        delegate?.didSelectOption(.nearby)
    }
    @objc func handlePopularFilterButtonTapped(){
        delegate?.didSelectOption(.popular)
    }
    @objc func handleHighestRatedFilterButtonTapped(){
        delegate?.didSelectOption(.highestRate)
    }
}
