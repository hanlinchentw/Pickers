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
    didSet { configure() }
  }

	private let restaurantImageView: UIImageView = {
		let iv = UIImageView()
		iv.clipsToBounds = true
		iv.layer.cornerRadius = 16
		iv.backgroundColor = .lightlightGray
		iv.contentMode = .scaleAspectFill
		return iv
	}()

  private let restaurantName: UILabel = .init(font: .arial14BoldMT, color: .black)

  private let priceLabel: UILabel = .init(font: .arial12MT, color: .systemGray)

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
    restaurantImageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor,
                           paddingTop: 8, paddingLeft:8, paddingRight: 8, height: 130)

    addSubview(selectButton)
    selectButton.anchor(top: restaurantImageView.topAnchor, right: restaurantImageView.rightAnchor, paddingRight: 8)

		addSubview(likeButton)
		likeButton.anchor(top: restaurantImageView.bottomAnchor, right: rightAnchor, paddingTop: 8, paddingRight: 16)
		likeButton.setDimension(width: 32, height: 32)

    let captionStack = UIStackView(arrangedSubviews: [restaurantName, priceLabel, ratedLabel])
		captionStack.distribution = .fillEqually
    captionStack.spacing = 4
    captionStack.axis = .vertical
    
		addSubview(captionStack)
		captionStack.anchor(top: restaurantImageView.bottomAnchor, left: leftAnchor, right: likeButton.leftAnchor, bottom: bottomAnchor,
											 paddingTop: 8, paddingLeft: 16, paddingRight: 16, paddingBottom: 8)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.restaurantImageView.image = nil
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
    delegate?.didTapLikeButton(restaurant: presenter.restaurant)
  }

  func configure(){
    guard let presenter = presenter else {
      return
    }
    layer.cornerRadius = 16
    layer.masksToBounds = true
    restaurantName.text = presenter.name
    priceLabel.text = presenter.priceCategoryDistanceText
		ratedLabel.attributedText = presenter.ratingAndReviewCountString
    selectButton.setImage(UIImage(named: presenter.actionButtonImage)?
      .withRenderingMode(.alwaysOriginal), for: .normal)
    likeButton.setImage(UIImage(named: presenter.likeButtonImage)?
      .withRenderingMode(.alwaysOriginal) , for: .normal)
		
		if let urlString = presenter.imageUrl,
			let imageUrl = URL(string: urlString) {
			restaurantImageView.af.setImage(withURL: imageUrl)
		}
  }
}
