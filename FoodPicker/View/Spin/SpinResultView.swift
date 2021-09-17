//
//  SpinResultView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/21.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit

class SpinResultView : UIView {
    //MARK: - Properties
    let restaurant: Restaurant
    private lazy var optionImageView : UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.backgroundColor = UIColor(white: 0.9, alpha: 1)
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    private lazy var  restaurantName : UILabel = {
        let label = UILabel()
        label.isSkeletonable = true
        label.font = UIFont(name: "Avenir-Heavy", size: 16)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()
    private lazy var  businessLabel : UILabel = {
        let label = UILabel()
        label.isSkeletonable = true
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .freshGreen
        return label
    }()
    private lazy var  priceLabel = UILabel()
    private lazy var  ratedLabel = UILabel()
    //MARK: - Lifecycle
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        super.init(frame: .zero)
        configure()
        fillInInfo()
        animateIn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    private func configure() {
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.masksToBounds = true
        addSubview(optionImageView)
        let imageHeight = 130 * heightMultiplier
        optionImageView.anchor(top:topAnchor, left: leftAnchor, right: rightAnchor,
                               paddingTop: 8, paddingLeft:8, paddingRight: 8, height: imageHeight)
        
       
        let captionStack = UIStackView(arrangedSubviews: [restaurantName, businessLabel, priceLabel, ratedLabel])
        captionStack.distribution = .fillProportionally
        captionStack.spacing = 4
        captionStack.axis = .vertical
        addSubview(captionStack)
        captionStack.anchor(top: optionImageView.bottomAnchor, left: leftAnchor,bottom: bottomAnchor,
                            paddingTop: 8, paddingLeft: 16, paddingBottom: 8)
    }
    private func fillInInfo() {
        let viewModel = CardCellViewModel(restaurant: restaurant)
        layer.cornerRadius = 16
        layer.masksToBounds = true
        restaurantName.text = restaurant.name
        priceLabel.attributedText = viewModel.priceString
        ratedLabel.attributedText = viewModel.ratedString
        businessLabel.attributedText = viewModel.businessString
        optionImageView.af.setImage(withURL: restaurant.imageUrl)
    }
    //MARK: - Animation
    func animateIn() {
        optionImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        restaurantName.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        businessLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        priceLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        ratedLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn) {
            self.optionImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.restaurantName.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.businessLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.priceLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.ratedLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
        }

    }
}
