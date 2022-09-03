//
//  RestaurantCardCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/3.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit

protocol RestaurantCardCellDelegate: AnyObject {
  func didTapSelectButton(restaurant: RestaurantViewObject)
  func didTapLikeButton(restaurant: RestaurantViewObject)
}

class RestaurantCardCell: UICollectionViewCell {
  weak var delegate: RestaurantCardCellDelegate?

  var presenter: RestaurantPresenter? {
    didSet {
      configure()
    }
  }

  private let restaurantImageView = CachedImageView()

  private let restaurantName: UILabel = .init(font: .arialBoldMT, color: .black)

  private let businessLabel : UILabel = .init(font: .boldSystemFont(ofSize: 14), color: .freshGreen)

  private let priceLabel: UILabel = .init(font: .arialMT, color: .systemGray)

  private lazy var selectButton : UIButton = {
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(handleSelectButtonTapped), for: .touchUpInside)
    return button
  }()

  private let ratedLabel = UILabel()

  private lazy var likeButton : UIButton = {
    let button = UIButton(type:.system)
    button.addTarget(self, action: #selector(handleLikeButtonTapped), for: .touchUpInside)
    return button
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    layer.cornerRadius = 16
    layer.masksToBounds = true
    addSubview(restaurantImageView)
    let imageHeight = 130 * heightMultiplier
    restaurantImageView.anchor(top:topAnchor, left: leftAnchor, right: rightAnchor,
                           paddingTop: 8, paddingLeft:8, paddingRight: 8, height: imageHeight)

    addSubview(selectButton)
    selectButton.anchor(top: restaurantImageView.topAnchor, right: restaurantImageView.rightAnchor, paddingRight: 8)

    addSubview(likeButton)
    likeButton.anchor(top:restaurantImageView.bottomAnchor, right:rightAnchor, paddingRight: 8,
                      width: 48, height: 48)

    let captionStack = UIStackView(arrangedSubviews: [restaurantName, businessLabel, priceLabel, ratedLabel])
    captionStack.distribution = .fillProportionally
    captionStack.spacing = 4
    captionStack.axis = .vertical
    addSubview(captionStack)
    captionStack.anchor(top: restaurantImageView.bottomAnchor, left: leftAnchor,bottom: bottomAnchor,
                        paddingTop: 8, paddingLeft: 16, paddingBottom: 8)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc func handleSelectButtonTapped() {
    guard let presenter = presenter else {
      return
    }
    
    delegate?.didTapSelectButton(restaurant: presenter.restaurant)
  }

  @objc func handleLikeButtonTapped() {
    guard let presenter = presenter else {
      return
    }
    delegate?.didTapSelectButton(restaurant: presenter.restaurant)
  }

  func configure(){
    guard let presenter = presenter else {
      return
    }
    layer.cornerRadius = 16
    layer.masksToBounds = true
    restaurantName.text = presenter.name
    priceLabel.text = presenter.priceCategoryDistanceText
    composeRatedLabel(rating: presenter.rating, reviewCount: presenter.reviewCount)
    businessLabel.text = presenter.openOrCloseString
    restaurantImageView.url = presenter.imageUrl
    selectButton.setImage(UIImage(named: presenter.actionButtonImage)?
      .withRenderingMode(.alwaysOriginal), for: .normal)
    likeButton.setImage(UIImage(named: presenter.likeButtonImage)?
      .withRenderingMode(.alwaysOriginal) , for: .normal)
  }

  func composeRatedLabel(rating: String, reviewCount: String) {
    let attributedString = NSMutableAttributedString(string: "★", attributes: .systemYellow)
    attributedString.append(NSAttributedString(string: " \(rating)", attributes: .attributes([.black, .arial14])))
    attributedString.append(NSAttributedString(string: " \(reviewCount)", attributes: .attributes([.lightGray, .arial14])))

    let paragraph = NSMutableParagraphStyle()
    paragraph.lineSpacing = 2
    attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraph, range: NSRange(0 ..< attributedString.length))
    ratedLabel.attributedText = attributedString
  }
}
