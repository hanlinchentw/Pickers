//
//  DetailHeader.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/31.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import ImageSlideshow

private let photoCellIdentifier = "PhotoCell"

class DetailHeader : UICollectionReusableView {
	//MARK: - Properties
	var presenter: DetailHeaderPresenter? { didSet{ configureHeaderInformation()} }
	var slideShowOrigin: CGRect?
	private let slideShow = ImageSlideshow()
	
	private lazy var backbutton : UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(named: "icnBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
		button.addTarget(self, action: #selector(handleDismissDetailPage), for: .touchUpInside)
		button.backgroundColor = .white
		button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
		button.layer.cornerRadius = 16
		button.layer.masksToBounds = true
		return button
	}()
	
	private lazy var shareButton : UIButton = {
		let button = UIButton(type: .system)
		button.backgroundColor = .white
		button.setImage(UIImage(named: "icnShare")?.withRenderingMode(.alwaysOriginal), for: .normal)
		button.addTarget(self, action: #selector(handleShareButtonTapped), for: .touchUpInside)
		button.layer.cornerRadius = 10
		button.anchor(width : 40, height: 40)
		
		return button
	}()
	
	private lazy var likeButton : UIButton = {
		let button = UIButton(type: .system)
		button.backgroundColor = .white
		button.setImage(UIImage(named: "icnHeart")?.withRenderingMode(.alwaysOriginal), for: .normal)
		button.addTarget(self, action: #selector(handleLikeButtonTapped), for: .touchUpInside)
		button.layer.cornerRadius = 10
		button.anchor(width : 40, height: 40)
		return button
	}()
	
	private let pageControl : UIPageControl = {
		let pc = UIPageControl()
		pc.numberOfPages = 3
		pc.currentPage = 0
		pc.currentPageIndicatorTintColor = .customblack
		pc.pageIndicatorTintColor = .white
		return pc
	}()
	//MARK: - Lifecycle
	override init(frame: CGRect) {
		super.init(frame:frame)
		configureUI()
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
		self.addGestureRecognizer(tap)
		self.isUserInteractionEnabled = true
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	//MARK: - Helpers
	func configureHeaderInformation(){
		guard let presenter = self.presenter else {return}
		let likeButtonImage = UIImage(named: presenter.likeButtonImageName)?.withRenderingMode(.alwaysOriginal)
		self.likeButton.setImage(likeButtonImage, for: .normal)

		slideShow.contentScaleMode = .scaleAspectFill
		let pageIndicator = UIPageControl()
		pageIndicator.pageIndicatorTintColor = UIColor.customblack
		slideShow.setImageInputs(presenter.imageSource)
	}
	//MARK: - Selectors
	@objc func handleDismissDetailPage(){
		presenter?.dismissDetailPage()
	}
	@objc func handleLikeButtonTapped(){
		presenter?.likeButtonTapped()
	}
	
	@objc func handleShareButtonTapped(){
		presenter?.shareButtonTapped()
	}
	
	@objc func handleTap() {
		presenter?.pushToSlideShowController()
	}
}

//MARK: - Autolayout
extension DetailHeader {
	fileprivate func configureUI() {
		slideShow.backgroundColor = UIColor.init(white: 0.2, alpha: 0.5)
		addSubview(slideShow)
		slideShow.fit(inView: self)

		addSubview(backbutton)
		backbutton.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, paddingTop: 56)
		backbutton.setDimension(width: 58, height: 40)

		addSubview(shareButton)
		shareButton.centerY(inView: backbutton)
		shareButton.anchor(right:rightAnchor, paddingRight: 8)
		
		addSubview(likeButton)
		likeButton.centerY(inView: backbutton)
		likeButton.anchor(right:shareButton.leftAnchor, paddingRight: 8)
	}
}
