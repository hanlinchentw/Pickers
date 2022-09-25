//
//  SpinResultView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/21.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit
import Combine

protocol SpinResultViewDelegate: AnyObject {
	func pushToDetailVC(_ restaurant: RestaurantViewObject)
	func openMap(_ restaurant: RestaurantViewObject)
}

class SpinResultView : UIView {
	//MARK: - Properties
	weak var delegate: SpinResultViewDelegate?
	@Published var restaurant: RestaurantViewObject? = nil
	
	private let nilResultImageView : UIImageView = {
		let iv = UIImageView()
		iv.contentMode = .scaleAspectFit
		iv.image = UIImage(named: "hungryGirl")?.withRenderingMode(.alwaysOriginal)
		return iv
	}()
	
	private let descriptionLabel = UILabel("What's for today?", font: .arial16BoldMT, color: .black)
	private lazy var restaurantImageView = CachedImageView()
	private lazy var  restaurantName = UILabel("Starbucks", font: UIFont(name: "Avenir-Heavy", size: 16)!, color: .black)
	private lazy var  priceLabel = UILabel("", font: .arial14MT, color: .gray)
	private lazy var  businessLabel = UILabel("Open", font: .arial14BoldMT, color: .freshGreen)
	private lazy var  ratedLabel = UILabel()
	
	private lazy var labelStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [restaurantName, businessLabel, priceLabel, ratedLabel])
		stack.distribution = .fillProportionally
		stack.spacing = 8
		stack.axis = .vertical
		return stack
	}()
	
	private lazy var mapButton: UIButton = {
		let btn = UIButton()
		btn.setImage(UIImage(named: "btnGoogleMaps"), for: .normal)
		btn.layer.masksToBounds = false
		btn.layer.shadowColor = UIColor(white: 0, alpha: 0.7).cgColor
		btn.layer.shadowOffset = CGSize(width: 0, height: 0)
		btn.layer.shadowOpacity = 0.3
		btn.layer.shadowRadius = 3
		btn.addTarget(self, action: #selector(handleMapButtonOnPressed), for: .touchUpInside)

		let roundedTransparentView = UIView()
		roundedTransparentView.backgroundColor = .clear
		roundedTransparentView.layer.cornerRadius = 12
		roundedTransparentView.layer.masksToBounds = true

		btn.addSubview(roundedTransparentView)
		roundedTransparentView.fit(inView: btn)
		return btn
	}()
	
	private lazy var containerView: UIView = {
		let view = UIView()
		view.addSubview(restaurantImageView)
		restaurantImageView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8)
		restaurantImageView.setDimension(height: 130)
		view.addSubview(labelStack)
		labelStack.anchor(top: restaurantImageView.bottomAnchor, left: view.leftAnchor, paddingTop: 8, paddingLeft: 16)
		view.addSubview(mapButton)
		mapButton.anchor(right: view.rightAnchor, bottom: view.bottomAnchor, paddingRight: 12, paddingBottom: 12)
		return view
	}()
	
	var set = Set<AnyCancellable>()
	//MARK: - Lifecycle
	init() {
		super.init(frame: .zero)
		configureTitleLabel()
		configureNilResultView()
		configureResultView()
		bindResult()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	//MARK: - Selectors
	@objc func handleResultViewTapped(){
		guard let result = self.restaurant else { return }
		delegate?.pushToDetailVC(result)
	}
	
	@objc func handleMapButtonOnPressed() {
		guard let result = self.restaurant else { return }
		delegate?.openMap(result)
	}
	
	// MARK: - Binding
	func bindResult() {
		$restaurant.sink { nullableViewObject in
			if let viewObject = nullableViewObject {
				self.showResult(result: viewObject)
			} else {
				self.hideResult()
			}
		}
		.store(in: &set)
	}
	//MARK: - Helpers
	func configureTitleLabel() {
		addSubview(descriptionLabel)
		descriptionLabel.centerX(inView: self)
		descriptionLabel.anchor(top: topAnchor)
	}
	
	func configureNilResultView(){
		addSubview(nilResultImageView)
		nilResultImageView.anchor(top: descriptionLabel.bottomAnchor, paddingTop: 16)
		nilResultImageView.setDimension(width: 200, height: 200)
		nilResultImageView.centerX(inView: self)
	}
	
	private func configureResultView() {
		containerView.alpha = 0
		containerView.backgroundColor = .white
		containerView.layer.cornerRadius = 16
		containerView.layer.masksToBounds = true
		addSubview(containerView)
		containerView.anchor(top: descriptionLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 16)
	}
	
	private func configureResult(result: RestaurantViewObject) {
		let presenter = RestaurantPresenter(restaurant: result, actionButtonMode: .none)
		layer.cornerRadius = 16
		layer.masksToBounds = true
		restaurantName.text = result.name
		
		priceLabel.text = presenter.priceCategoryDistanceText
		composeRatedLabel(rating: presenter.rating, reviewCount: presenter.reviewCount)
		businessLabel.text = presenter.openOrCloseString
		restaurantImageView.url = presenter.imageUrl
		configureResultView()
	}
	
	func composeRatedLabel(rating: String, reviewCount: String) {
		let attributedString = NSMutableAttributedString(string: "★", attributes: .attributes([.systemYellow, .arial12]))
		attributedString.append(NSAttributedString(string: " \(rating)", attributes: .attributes([.black, .arial12])))
		attributedString.append(NSAttributedString(string: " \(reviewCount)", attributes: .attributes([.lightGray, .arial12])))
		let paragraph = NSMutableParagraphStyle()
		paragraph.lineSpacing = 2
		attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraph, range: NSRange(0 ..< attributedString.length))
		ratedLabel.attributedText = attributedString
	}
	
	func showResult(result: RestaurantViewObject) {
		configureResult(result: result)
		UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut) {
			self.descriptionLabel.text = "“\(result.name)” for today 😋"
			self.containerView.alpha = 1
			self.nilResultImageView.alpha = 0
		}
	}
	
	func hideResult() {
		descriptionLabel.text = "What's for today?"
		UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
			self.containerView.alpha = 0
			self.nilResultImageView.alpha = 1
			self.descriptionLabel.alpha = 1
		}
	}
}
