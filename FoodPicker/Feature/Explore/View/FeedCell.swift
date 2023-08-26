//
//  FeedCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/7/3.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit
import ImageSlideshow

protocol FeedCellDelegate: AnyObject {
	func didTapAddButton(object: RestaurantViewObject)
}

class FeedCell: UICollectionViewCell {
	weak var delegate: FeedCellDelegate?

	var viewObject: RestaurantViewObject?

	private let slideShow = with(ImageSlideshow()) {
		$0.backgroundColor = UIColor.init(white: 0.2, alpha: 0.5)
		$0.contentScaleMode = .scaleAspectFill
		$0.layer.cornerRadius = 16
	}
	
	private lazy var addButton = with(UIButton()) {
		$0.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
		$0.setDimension(width: 48, height: 48)
	}
	
	private let nameLabel = UILabel(font: .arial16BoldMT)
	
	private let statusLabel = UILabel(font: .arial14BoldMT)

	private let infosLabel = UILabel(font: .arial14MT, color: .gray)
	
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

	func setupUI() {
		addSubview(slideShow)
		slideShow.anchor(top: topAnchor)
		slideShow.anchor(left: leftAnchor)
		slideShow.anchor(right: rightAnchor)
		slideShow.setDimension(height: 275)

		slideShow.addSubview(addButton)
		addButton.anchor(top: slideShow.topAnchor)
		addButton.anchor(right: slideShow.rightAnchor)
		
		addSubview(stackView)
		stackView.anchor(top: slideShow.bottomAnchor, paddingTop: 16)
		stackView.anchor(left: leftAnchor)
		stackView.anchor(right: rightAnchor)
	}

	func configure() {
		guard let viewObject = viewObject else { return }
		let imageSources = viewObject.imageUrls.compactMap {$0}.map { AlamofireSource(url: $0) }
		slideShow.setImageInputs(imageSources)
		nameLabel.text = viewObject.name
		statusLabel.text = viewObject.isClosed ? "Cloesd" : "Open"
		statusLabel.textColor = viewObject.isClosed ? .red : .freshGreen
		let addButtonImage = viewObject.isSelected ? UIImage(named: R.image.icnOvalSelected.name) : UIImage(named: R.image.addL.name)
		addButton.setImage(addButtonImage, for: .normal)
		infosLabel.text = "$\(viewObject.price ?? "100")・\(viewObject.businessCategory ?? "Food")・\(300)m away"
	}
	
	@objc func didTapAddButton() {
		if let viewObject {
			delegate?.didTapAddButton(object: viewObject)
		}
	}
}
