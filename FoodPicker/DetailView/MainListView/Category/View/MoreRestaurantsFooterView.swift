//
//  SeeMoreFooterView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/11/8.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

protocol MoreRestaurantsFooterViewDelegate: class {
    func shouldShowMoreRestaurants()
}

class MoreRestaurantsFooterView: UICollectionReusableView{
    weak var delegate: MoreRestaurantsFooterViewDelegate?
    private lazy var seeMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named:"btnSeeMore")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimension(width: 56, height: 56)
        button.addTarget(self, action: #selector(handleSeeMoreButtonTapped), for: .touchUpInside)
        return button
    }()
    private let seeMoreLabel : UILabel = {
        let label = UILabel()
        label.text = "See more"
        label.font = UIFont(name: "Arial-BoldMT", size: 14)
        
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundColor
        let stack = UIStackView(arrangedSubviews: [seeMoreButton, seeMoreLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 8
        stack.alignment = .center
        addSubview(stack)
        stack.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Selectors
    @objc func handleSeeMoreButtonTapped(){
        delegate?.shouldShowMoreRestaurants()
    }
}
