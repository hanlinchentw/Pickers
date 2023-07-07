//
//  FeedCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/7/3.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit
import ImageSlideshow

class FeedCell: UICollectionViewCell {
	private let slideShow = with(ImageSlideshow()) {
		$0.backgroundColor = UIColor.init(white: 0.2, alpha: 0.5)
		$0.contentScaleMode = .scaleAspectFit
	}
	
	private let nameLabel = UILabel(font: .arial16BoldMT)
	
	private let statusLabel = UILabel(font: .arial14BoldMT, color: .gray)

	private let infosLabel = UILabel(font: .arial14MT)
	
	private lazy var stackView = with(UIStackView(arrangedSubviews: [nameLabel, statusLabel, infosLabel])) {
		$0.axis = .vertical
		$0.spacing = 4
		$0.distribution = .fill
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		self.contentView.subviews.forEach { $0.removeFromSuperview() }
	}
	
	func setupUI() {
		addSubview(slideShow)
		slideShow.anchor(top: topAnchor, paddingTop: 8)
		slideShow.anchor(left: leftAnchor, paddingLeft: 8)
		slideShow.anchor(right: rightAnchor, paddingRight: 8)
		slideShow.setDimension(height: 320)

		addSubview(stackView)
		stackView.anchor(top: slideShow.bottomAnchor, paddingTop: 8)
		stackView.anchor(left: leftAnchor, paddingLeft: 8)
		stackView.anchor(right: rightAnchor, paddingRight: 8)
	}

	func configure(viewObject: RestaurantViewObject) {
		let imageSources = viewObject.imageUrls.compactMap {$0}.map { AlamofireSource(url: $0) }
		slideShow.setImageInputs(imageSources)
		nameLabel.text = viewObject.name
		statusLabel.text = viewObject.isClosed ? "Cloesd" : "Open"
		statusLabel.textColor = viewObject.isClosed ? .red : .freshGreen
		infosLabel.text = "$\(viewObject.price ?? "100")・\(viewObject.businessCategory ?? "Food")・\(300)m away"
	}
}
