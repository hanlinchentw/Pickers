//
//  PlaceListViewCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/27.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit
import Kingfisher

protocol PlaceListViewCellDelegate: AnyObject {
	func didTapAddButton(viewModel: PlaceListViewModel)
}

class PlaceListViewCell: UICollectionViewCell {
	weak var delegate: PlaceListViewCellDelegate?

	var viewModel: PlaceListViewModel?

	private let imageView: UIImageView = {
		let iv = UIImageView()
		iv.backgroundColor = UIColor.init(white: 0.2, alpha: 0.5)
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		iv.layer.cornerRadius = 16
		return iv
	}()

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
		addSubview(imageView)
		imageView.anchor(top: topAnchor)
		imageView.anchor(left: leftAnchor)
		imageView.anchor(right: rightAnchor)
		imageView.setDimension(height: 275)

		addSubview(addButton)
		addButton.anchor(top: imageView.topAnchor)
		addButton.anchor(right: imageView.rightAnchor)
		
		addSubview(stackView)
		stackView.anchor(top: imageView.bottomAnchor, paddingTop: 16)
		stackView.anchor(left: leftAnchor)
		stackView.anchor(right: rightAnchor)
	}

	func configure() {
		guard let viewModel = viewModel else { return }
		if let imageUrl = viewModel.imageUrls[safe: 0] as? URL {
			imageView.kf.setImage(with: imageUrl)
		}
		nameLabel.text = viewModel.name
		statusLabel.text = viewModel.isClosed ? "Cloesd" : "Open"
		statusLabel.textColor = viewModel.isClosed ? .red : .freshGreen
		let addButtonImage = viewModel.isSelected ? UIImage(named: R.image.icnOvalSelected.name) : UIImage(named: R.image.addL.name)
		addButton.setImage(addButtonImage, for: .normal)
		infosLabel.text = "$\(viewModel.price ?? "100")・\(viewModel.businessCategory ?? "Food")・\(300)m away"
	}
	
	@objc func didTapAddButton() {
		if let viewModel {
			delegate?.didTapAddButton(viewModel: viewModel)
		}
	}
}
