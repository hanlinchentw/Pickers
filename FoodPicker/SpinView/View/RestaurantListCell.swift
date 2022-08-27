//
//  FavoriteCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/7.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

protocol RestaurantListCellDelegate: AnyObject {
  func didTapActionButton(_ restaurant : Restaurant)
}

class RestaurantListCell : UITableViewCell {
  //MARK: - Properties
  var presenter: RestaurantPresenter? { didSet { configure() } }
  private let restaurantImageView = CachedImageView()
  weak var delegate: RestaurantListCellDelegate?
  // MARK: - Components
  private let restaurantName : UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Avenir-Heavy", size: 16)
    label.textAlignment = .left
    label.textColor = .black
    return label
  }()

  private let priceLabel: UILabel = {
    let label = UILabel()
    label.textColor = .lightGray
    label.font = .arialMT
    return label
  }()

  lazy var actionButton : UIButton = {
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(handleActionButtonTapped), for: .touchUpInside)
    return button
  }()

  private let ratedLabel = UILabel()
  //MARK: - Lifecycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    self.restaurantName.text = nil
    self.ratedLabel.text = nil
    self.priceLabel.text = nil
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
    addSubview(restaurantImageView)
    let imageHeight = 93 * widthMultiplier
    restaurantImageView.anchor(left: leftAnchor, paddingLeft: 12, width: imageHeight, height: imageHeight)
    restaurantImageView.centerY(inView: self)
    contentView.addSubview(actionButton)
    actionButton.anchor(right: rightAnchor, paddingRight: 12, width: 48, height: 48)
    actionButton.centerY(inView: self)

    let captionStack = UIStackView(arrangedSubviews: [restaurantName, priceLabel, ratedLabel])
    captionStack.distribution = .fillEqually
    captionStack.spacing = 0
    captionStack.axis = .vertical
    addSubview(captionStack)
    captionStack.anchor(left: restaurantImageView.rightAnchor, right: actionButton.leftAnchor,
                        paddingLeft: 16, paddingRight: 8)
    captionStack.centerY(inView: self)
  }

  func configure(){
    guard let presenter = presenter else { return }
    print("Restaurant.configure")
    restaurantName.text = presenter.name
    priceLabel.text = presenter.thirdRowString
    restaurantImageView.url = presenter.imageUrl
    actionButton.setImage(UIImage(named: presenter.actionButtonImage)?.withRenderingMode(.alwaysOriginal), for: .normal)
    composeRatedLabel(rating: presenter.ratingWithOneDecimal, reviewCount: presenter.reviewCount)
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
