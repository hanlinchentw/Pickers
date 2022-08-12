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
  var presenter: RestaurantCardPresenter? { didSet { configureUI() } }
  weak var delegate : RestaurantAPI?

  let optionImageView : UIImageView = {
    let iv = UIImageView()
    iv.clipsToBounds = true
    iv.layer.cornerRadius = 16
    iv.backgroundColor = UIColor(white: 0.9, alpha: 1)
    iv.contentMode = .scaleAspectFill
    return iv
  }()

  let restaurantName : UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Avenir-Heavy", size: 16)
    label.textAlignment = .left
    label.numberOfLines = 1
    label.textColor = .black
    return label
  }()

  let businessLabel : UILabel = {
    let label = UILabel()
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
    setupUI()
  }
  deinit {
    print("DEBUG: Retain cycle is not occuring ...")
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  //MARK: - Helpers
  func configureUI() {
    if let presenter = presenter {
      restaurantName.text = presenter.name
      priceLabel.attributedText = presenter.priceString
      ratedLabel.attributedText = presenter.ratedString
      businessLabel.attributedText = presenter.businessString
      optionImageView.af.setImage(withURL: presenter.imageUrl)
      selectButton.setImage(UIImage(named: presenter.selectButtonImagename)?
        .withRenderingMode(.alwaysOriginal), for: .normal)
      likeButton.setImage(UIImage(named: presenter.likeButtonImagename)?
        .withRenderingMode(.alwaysOriginal) , for: .normal)
    }
  }
  //MARK: - Selectors
  @objc func handleLikeButtonTapped(){
//    guard self.restaurant != nil else { return }
    //        self.delegate?.didLikeRestaurant(restaurant: self.restaurant!)
  }
  @objc func handleSelectButtonTapped(){
//    guard self.restaurant != nil else { return }
    //        self.delegate?.didSelectRestaurant(restaurant: self.restaurant!)
  }
}

extension RestaurantCardCell {
  func setupUI() {
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
}
