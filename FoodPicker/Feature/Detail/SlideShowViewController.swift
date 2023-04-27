//
//  SlideShowViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/29.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit
import ImageSlideshow

class SlideShowViewController: UIViewController {
	private let slideShow = ImageSlideshow()
	private lazy var backbuttonContainerView : UIView = {
		let view = UIView()
		view.backgroundColor = .white
		let button = UIButton(type: .system)
		button.setImage(UIImage(systemName: "xmark"), for: .normal)
		button.imageView?.tintColor = .black
		button.tintColor = .black
		button.addTarget(self, action: #selector(handleDismissDetailPage), for: .touchUpInside)
		
		view.addSubview(button)
		button.center(inView: view)
		button.setDimension(width: 16, height: 16)
		button.centerY(inView: view)
		view.setDimension(width: 40, height: 40)
		view.layer.cornerRadius = 20
		view.layer.masksToBounds = true
		return view
	}()
	
	init(photos: Array<AlamofireSource>) {
		super.init(nibName: nil, bundle: nil)

		slideShow.contentScaleMode = .scaleAspectFit
		let pageIndicator = UIPageControl()
		pageIndicator.pageIndicatorTintColor = UIColor.customblack
		slideShow.setImageInputs(photos)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureUI()
		let panGes = UIPanGestureRecognizer(target: self, action: #selector(panGesture(gesture:)))
		self.view.addGestureRecognizer(panGes)
		self.view.isUserInteractionEnabled = true
	}
	
	@objc func handleDismissDetailPage(){
		self.dismiss(animated: true)
	}
}

extension SlideShowViewController {
	fileprivate func configureUI() {
		slideShow.backgroundColor = UIColor.init(white: 0.2, alpha: 0.5)
		view.addSubview(slideShow)
		slideShow.fit(inView: view)

		view.addSubview(backbuttonContainerView)
		backbuttonContainerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 32)
	}
}

extension SlideShowViewController: UIGestureRecognizerDelegate {
	@objc func panGesture(gesture: UIPanGestureRecognizer) {
		let yTranslation = gesture.translation(in: self.view).y
		if abs(yTranslation) > 50 {
			self.dismiss(animated: true)
		}
	}
}
