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
	
	private lazy var backbuttonContainerView : UIView = {
		let view = UIView()
		view.backgroundColor = .white
		let button = UIButton(type: .system)
		button.setImage(UIImage(named: "icnBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
		button.addTarget(self, action: #selector(handleDismissDetailPage), for: .touchUpInside)
		
		view.addSubview(button)
		button.anchor(right:view.rightAnchor, paddingRight: 8,
									width: 32, height: 32)
		button.centerY(inView: view)
		
		view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
		view.layer.cornerRadius = 16
		view.layer.masksToBounds = true
		return view
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
		addGestureForHeader()
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
		presenter?.pushToSlideShowController(photos: presenter?.imageSource ?? [])
	}
}

//MARK: - Autolayout
extension DetailHeader {
	fileprivate func configureUI() {
		slideShow.backgroundColor = UIColor.init(white: 0.2, alpha: 0.5)
		addSubview(slideShow)
		slideShow.fit(inView: self)
		addSubview(backbuttonContainerView)
		backbuttonContainerView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor,
																	 paddingTop: 56,
																	 width: 58, height: 40)
		addSubview(shareButton)
		shareButton.centerY(inView: backbuttonContainerView)
		shareButton.anchor(right:rightAnchor, paddingRight: 8)
		
		addSubview(likeButton)
		likeButton.centerY(inView: backbuttonContainerView)
		likeButton.anchor(right:shareButton.leftAnchor, paddingRight: 8)
	}
	
	func addGestureForHeader() {
		slideShow.isUserInteractionEnabled = true
		
		let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(recognizer:)))
		gesture.delegate = self
		slideShow.addGestureRecognizer(gesture)
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
		slideShow.addGestureRecognizer(tap)
	}
}

extension DetailHeader: UIGestureRecognizerDelegate {
	@objc func panGesture(recognizer: UIPanGestureRecognizer) {
		let translation = recognizer.translation(in: slideShow)
		let oldYPosition = slideShow.frame.minY
		let newYPosition = oldYPosition + translation.y
		switch recognizer.state {
		case .changed:
			
			
			let scale = translation.y > 0  ? 1 + 0.03 * (slideShow.frame.maxX - 300)/10 : 1 - 0.03 * (slideShow.frame.maxX - 300)/10
			UIView.animate(withDuration: 0.3, delay: 0) {
				self.slideShow.transform = CGAffineTransform(scaleX: scale, y: scale)
			}
			recognizer.setTranslation(.zero, in: self)
		case .ended:
			if slideShow.frame.maxY >= UIScreen.screenHeight / 2.5 {
				presenter?.pushToSlideShowController(photos: presenter?.imageSource ?? [])
			}
			UIView.animate(withDuration: 0.3, delay: 0.5) {
				self.slideShow.transform = .identity
			}
		default: break
		}
	}
}
