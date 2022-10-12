//
//  SearchTextField.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/10/8.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit

class SearchTextField: UITextField {
	override init(frame: CGRect) {
		super.init(frame: frame)
		placeholder = "Search for restaurants"
		layer.cornerRadius = 12
		setDimension(height:  40)
		backgroundColor = .white
		returnKeyType = .search
		clearButtonMode = .whileEditing
		
		let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
		imageView.contentMode = .scaleAspectFit
		imageView.tintColor = .lightGray
		leftView = imageView
		leftViewMode = .unlessEditing
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Insets
extension SearchTextField {
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return CGRectInset(bounds, 12, 0)
	}
	
	override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return CGRectInset(bounds, 36, 0)
	}

	override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
		return CGRectInset(CGRect(x: bounds.minX, y: bounds.minY, width: 44, height: 40), 12, 0)
	}
}
