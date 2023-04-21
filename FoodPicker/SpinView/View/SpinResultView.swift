//
//  SpinResultView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/21.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit
import Combine
import Kingfisher

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
	private lazy var restaurantImageView = UIImageView()
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
	
	private lazy var mapButton: UIImageView = {
		let view = UIImageView()
		view.layer.masksToBounds = false
		view.layer.shadowColor = UIColor(white: 0, alpha: 0.7).cgColor
		view.layer.shadowOpacity = 0.3
		view.layer.shadowOffset = CGSize(width: 0, height: 0)
		view.layer.shadowRadius = 3
		view.image = UIImage(named: "btnGoogleMaps")
		let shadowView = UIView()
		shadowView.backgroundColor = .clear
		shadowView.layer.cornerRadius = 12
		shadowView.layer.masksToBounds = true

		view.addSubview(shadowView)
		shadowView.fit(inView: view)
		let tap = UITapGestureRecognizer(target: self, action: #selector(handleMapButtonOnPressed))
		view.addGestureRecognizer(tap)
		view.isUserInteractionEnabled = true
		return view
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
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(handleResultViewTapped))
		view.addGestureRecognizer(tap)
		view.isUserInteractionEnabled = true
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
		ratedLabel.attributedText = presenter.ratingAndReviewCountString
		businessLabel.text = presenter.openOrCloseString
		
		if let urlString = presenter.imageUrl,
			 let imageUrl = URL(string: urlString) {
			restaurantImageView.kf.setImage(with: imageUrl)
		}
		
		configureResultView()
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
