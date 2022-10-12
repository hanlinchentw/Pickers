//
//  RestaurantListFooterView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/10/9.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit

class RestaurantListFooterView: UICollectionReusableView {
	var didTap: VoidClosure?
	
	private lazy var addButton: UIButton = {
		let btn = UIButton(type: .system)
		btn.addTarget(self, action: #selector(handleAddButtonTapped), for: .touchUpInside)
		btn.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
		btn.tintColor = .butterscotch
		return btn
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(addButton)
		addButton.center(inView: self)
		addButton.setDimension(width: 36, height: 36)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc func handleAddButtonTapped() {
		didTap?()
	}
}
