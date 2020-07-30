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
import RxSwift
import RxCocoa

protocol CardCellDelegate : class {
    func didSeletRestaurant(_ restaurant : Restaurant)
    func didLikeRestaurant(_ restaurant : Restaurant)
}

class CardCell : UICollectionViewCell {
    //MARK: - Properties
    var restaurant : Restaurant! {didSet{indicator.stopAnimating(); configure()}}
    private let optionImageView : UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.backgroundColor = .blue
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "new york")
        return iv
    }()
    weak var delegate : CardCellDelegate?
    private let restaurantName : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 16)
        label.text = "New York"
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let discountLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 14)
        label.text = "80% OFF"
        label.backgroundColor = .butterscotch
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        label.textColor = .white
        label.clipsToBounds = true
        return label
    }()
    
    private let businessLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 14)
        label.text = "OPEN"
        label.textAlignment = .left
        label.textColor = .freshGreen
        return label
    }()
    
    private let priceLabel = UILabel()
    
    private lazy var selectButton : UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleSelectButtonTapped), for: .touchUpInside)
        return button
    }()
    private let ratedLabel = UILabel()
    
    private lazy var likeButton : UIButton = {
        let button = UIButton(type:.system)
        button.addTarget(self, action: #selector(handleLikeButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "icnHeart")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private let indicator = UIActivityIndicatorView()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = .white
        layer.cornerRadius = 16
        addSubview(indicator)
        indicator.style = .large
        indicator.centerX(inView: self)
        indicator.centerY(inView: self)
        indicator.color = .black
        indicator.startAnimating()
        
        
        addSubview(optionImageView)
        optionImageView.anchor(top:topAnchor, left: leftAnchor, right: rightAnchor,bottom: bottomAnchor,
                               paddingTop: 8, paddingLeft:8, paddingRight: 8,paddingBottom: 104 )
        
        addSubview(selectButton)
        selectButton.anchor(top:optionImageView.topAnchor, right: optionImageView.rightAnchor,
                            paddingRight: 8,
                            width: 40, height: 40)
        
        addSubview(likeButton)
        likeButton.anchor(top:optionImageView.bottomAnchor, right:rightAnchor, paddingRight: 8,
                          width: 48, height: 48)
    
        let captionStack = UIStackView(arrangedSubviews: [restaurantName, businessLabel, priceLabel, ratedLabel])
        captionStack.distribution = .fillProportionally
        captionStack.spacing = 0
        captionStack.axis = .vertical
        addSubview(captionStack)
        captionStack.anchor(top:optionImageView.bottomAnchor, left: leftAnchor,bottom: bottomAnchor,
                            paddingTop: 8, paddingLeft: 16, paddingBottom: 8)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    func configure(){
        let viewModel = CardCellViewModel(restaurant: restaurant)
        
        restaurantName.text = restaurant.name
        priceLabel.attributedText = viewModel.priceString
        ratedLabel.attributedText = viewModel.ratedString
        businessLabel.attributedText = viewModel.businessString
        optionImageView.af.setImage(withURL: restaurant.imageUrl)
        selectButton.setImage(viewModel.selectButtonImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.tintColor = viewModel.heartColor
    }
    //MARK: - Selectors
    @objc
    func handleLikeButtonTapped(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: DID_LIKE_KEY),
                                    object: nil,
                                    userInfo: ["Restaurant":self.restaurant as Restaurant])
        self.restaurant.isLiked.toggle()
        self.delegate?.didLikeRestaurant(self.restaurant)
    }
    @objc
    func handleSelectButtonTapped(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: DID_SELECT_KEY),
                                    object: nil,
                                    userInfo: ["Restaurant":self.restaurant as Restaurant])
        self.restaurant.isSelected.toggle()
        self.delegate?.didSeletRestaurant(self.restaurant)
    }
}
