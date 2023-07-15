//
//  ExploreSearchBarView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/7/7.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit

class ExploreSearchBarView: UIView {
	private let searchIconImageView = with(UIImageView()) {
		$0.setDimension(width: 20, height: 20)
		$0.contentMode = .scaleAspectFit
		$0.image = UIImage(systemName: "magnifyingglass")
		$0.tintColor = .black
	}
	
	private let placeholderLabel = with(UILabel()) {
		$0.text = "What to eat?"
		$0.font = .arial14MT
		$0.textColor = .black
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupUI() {
		setDimension(height: 50)
		self.layer.masksToBounds = false
		backgroundColor = .white
		self.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
		self.layer.borderWidth = 0.5
		self.layer.cornerRadius = 25
		self.layer.shadowColor = UIColor.darkGray.cgColor
		self.layer.shadowOffset = CGSize(width: 0, height: 0)
		self.layer.shadowOpacity = 0.4
		self.layer.shadowRadius = 2
		
		self.addSubview(searchIconImageView)
		searchIconImageView.centerY(inView: self)
		searchIconImageView.anchor(left: leftAnchor, paddingLeft: 16)
		
		self.addSubview(placeholderLabel)
		placeholderLabel.centerY(inView: self)
		placeholderLabel.anchor(left: searchIconImageView.rightAnchor, paddingLeft: 16)
	}
}
