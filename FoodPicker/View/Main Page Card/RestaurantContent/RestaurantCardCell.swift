//
//  CardCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/6.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class RestaurantCardCell: UICollectionViewCell{
    //MARK: - Properties
    var restaurant : Restaurant? { didSet{ configure() }}
    
    let optionImageView : UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.backgroundColor = UIColor(white: 0.9, alpha: 1)
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    weak var delegate : RestaurantAPI?
    let restaurantName : UILabel = {
        let label = UILabel()
        label.isSkeletonable = true
        label.font = UIFont(name: "Avenir-Heavy", size: 16)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()
    let businessLabel : UILabel = {
        let label = UILabel()
        label.isSkeletonable = true
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .freshGreen
        return label
    }()
    let priceLabel = UILabel()
    lazy var selectButton : UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleSelectButtonTapped), for: .touchUpInside)
        return button
    }()
    let ratedLabel = UILabel()
 
    lazy var likeButton : UIButton = {
        let button = UIButton(type:.system)
        button.addTarget(self, action: #selector(handleLikeButtonTapped), for: .touchUpInside)
        return button
    }()

    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.masksToBounds = true
        addSubview(optionImageView)
        let imageHeight = 130 * heightMultiplier
        optionImageView.anchor(top:topAnchor, left: leftAnchor, right: rightAnchor,
                               paddingTop: 8, paddingLeft:8, paddingRight: 8, height: imageHeight)
        
        addSubview(selectButton)
        selectButton.anchor(top:optionImageView.topAnchor, right: optionImageView.rightAnchor,
                            paddingRight: 8,
                            width: 40, height: 40)
        
        addSubview(likeButton)
        likeButton.anchor(top:optionImageView.bottomAnchor, right:rightAnchor, paddingRight: 8,
                          width: 48, height: 48)
    
        let captionStack = UIStackView(arrangedSubviews: [restaurantName, businessLabel, priceLabel, ratedLabel])
        captionStack.distribution = .fillProportionally
        captionStack.spacing = 4
        captionStack.axis = .vertical
        addSubview(captionStack)
        captionStack.anchor(top: optionImageView.bottomAnchor, left: leftAnchor,bottom: bottomAnchor,
                            paddingTop: 8, paddingLeft: 16, paddingBottom: 8)
    }
    deinit {
        print("DEBUG: Retain cycle is not occuring ...")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    func configure(){
        guard let restaurant = restaurant else { return }
        let viewModel = CardCellViewModel(restaurant: restaurant)
        layer.cornerRadius = 16
        layer.masksToBounds = true
        restaurantName.text = restaurant.name
        priceLabel.attributedText = viewModel.priceString
        ratedLabel.attributedText = viewModel.ratedString
        businessLabel.attributedText = viewModel.businessString
        optionImageView.af.setImage(withURL: restaurant.imageUrl)
        selectButton.setImage(UIImage(named: viewModel.selectButtonImagename)?
                                .withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.setImage(UIImage(named: viewModel.likeButtonImagename)?
                                .withRenderingMode(.alwaysOriginal) , for: .normal)
    }
    //MARK: - Selectors
    @objc func handleLikeButtonTapped(){
        guard self.restaurant != nil else { return }
        self.delegate?.didLikeRestaurant(restaurant: self.restaurant!)
    }
    @objc func handleSelectButtonTapped(){
        guard self.restaurant != nil else { return }
        self.delegate?.didSelectRestaurant(restaurant: self.restaurant!)
    }
}
