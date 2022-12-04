//
//  FavoriteCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/7.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

protocol RestaurantListCellDelegate: AnyObject {
  func didTapActionButton(_ restaurant : RestaurantViewObject)
}

class RestaurantListCell: UICollectionViewCell {
  //MARK: - Properties
  var presenter: RestaurantPresenter? { didSet { configure() } }

	private let restaurantImageView: UIImageView = {
		let iv = UIImageView()
		iv.clipsToBounds = true
		iv.layer.cornerRadius = 16
		iv.backgroundColor = .lightlightGray
		iv.contentMode = .scaleAspectFill
		return iv
	}()

  weak var delegate: RestaurantListCellDelegate?
  // MARK: - Components
  private let restaurantName : UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Avenir-Heavy", size: 16)
		label.numberOfLines = 0
    label.textAlignment = .left
    label.textColor = .black
    return label
  }()

  private let priceLabel: UILabel = {
    let label = UILabel()
    label.textColor = .lightGray
    label.font = .arial14MT
    return label
  }()

  lazy var actionButton : UIButton = {
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(handleActionButtonTapped), for: .touchUpInside)
		button.setDimension(width: 44, height: 44)
    return button
  }()

  private let ratedLabel = UILabel()
  //MARK: - Lifecycle
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  //MARK: - Selectors
  @objc func handleActionButtonTapped(){
    guard let presenter = presenter else { return }
    self.delegate?.didTapActionButton(presenter.restaurant)
  }
}
// MARK: - UIConfiguration
extension RestaurantListCell {
  func setupUI() {
    backgroundColor = .white
    contentView.addSubview(actionButton)
    actionButton.anchor(right: rightAnchor, paddingRight: 8)
    actionButton.centerY(inView: self)

		restaurantImageView.setDimension(width: 93)
    let captionStack = UIStackView(arrangedSubviews: [restaurantName, priceLabel, ratedLabel])
		captionStack.distribution = .fillProportionally
    captionStack.spacing = 0
    captionStack.axis = .vertical

		let restaurantInfoStack = UIStackView(arrangedSubviews: [restaurantImageView, captionStack])
		restaurantInfoStack.distribution = .fillProportionally
		restaurantInfoStack.spacing = 16
		restaurantInfoStack.axis = .horizontal
		restaurantInfoStack.alignment = .center

		contentView.addSubview(restaurantInfoStack)
		restaurantInfoStack.anchor(
			top: topAnchor,
			left: leftAnchor,
			right: actionButton.leftAnchor,
			bottom: bottomAnchor,
			paddingTop: 8,
			paddingLeft: 16,
			paddingRight: 8,
			paddingBottom: 8
		)
  }

	func configure(){
		guard let presenter = presenter else { return }
		restaurantName.text = presenter.name

		actionButton.setImage(UIImage(named: presenter.actionButtonImage)?.withRenderingMode(.alwaysOriginal), for: .normal)
		
		priceLabel.text = presenter.priceCategoryDistanceText
		priceLabel.isHidden = priceLabel.text == nil
		
		ratedLabel.attributedText = presenter.ratingAndReviewCountString
		ratedLabel.isHidden = ratedLabel.text == nil

		if let imageUrlString = presenter.imageUrl,
			 let imageUrl = URL(string: imageUrlString) {
			restaurantImageView.af.setImage(withURL: imageUrl)
			restaurantImageView.isHidden = false
		} else {
			restaurantImageView.isHidden = true
		}
	}
}
