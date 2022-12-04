//
//  CategoryCardCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/10/9.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit

class CategoryCardCell: UICollectionViewCell {
	private let categoryImageView: UIImageView = {
		let iv = UIImageView()
		iv.clipsToBounds = true
		iv.layer.cornerRadius = 16
		iv.backgroundColor = .lightlightGray
		iv.contentMode = .scaleAspectFill
		return iv
	}()
	
	var imageName: String? {
		didSet {
			configureImage()
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(categoryImageView)
		categoryImageView.fit(inView: self)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configureImage() {
		if let imageName = imageName {
			categoryImageView.image = UIImage(named: imageName)
		}
	}
}
