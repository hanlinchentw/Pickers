//
//  FavoriteCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/7.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

class FavoriteCell : UICollectionViewCell {
    //MARK: - Properties
    var restaurant : Restaurant! {didSet{configure()}}
    private let optionImageView : UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.backgroundColor = .blue
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "new york")
        return iv
    }()
    
    private let restaurantName : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 16)
        label.text = "New York"
        label.textAlignment = .left
        return label
    }()
    private let priceLabel = UILabel()

    private let ratedLabel = UILabel()
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = . backgroundColor
        
        addSubview(optionImageView)
        optionImageView.anchor(top: topAnchor, left: leftAnchor, width: 88,height: 88)
        let captionStack = UIStackView(arrangedSubviews: [restaurantName, priceLabel, ratedLabel])
        captionStack.distribution = .fillProportionally
        captionStack.spacing = 0
        captionStack.axis = .vertical
        addSubview(captionStack)
        captionStack.anchor(left: optionImageView.rightAnchor, paddingLeft: 18)
        captionStack.centerY(inView: self)
       
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Selectors
    @objc func handleSelectButtonTapped(){
           
       }
    //MARK: - Helpers
    func configure(){
        let viewModel = CardCellViewModel(restaurant: restaurant)
        
        restaurantName.text = restaurant.name
        restaurantName.text = restaurant.name
        priceLabel.attributedText = viewModel.priceString
        ratedLabel.attributedText = viewModel.ratedString
        optionImageView.af.setImage(withURL: restaurant.imageUrl)
    }
}



