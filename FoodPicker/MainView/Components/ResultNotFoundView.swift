//
//  ResultNotFoundView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/10/10.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit

class ResultNotFoundView: UIView {
	private let noResultImageView: UIImageView = {
		let iv = UIImageView()
		iv.contentMode = .scaleAspectFit
		iv.clipsToBounds = true
		iv.image = UIImage(named: "illustrationSearchXresult")
		return iv
	}()
	
	private let titleLabel = UILabel("Sorry...", font: .arial24BoldMT, color: .black)
	private let descriptionLabel = UILabel(font: .arial16MT, color: UIColor(white: 0, alpha: 0.7))
	
	var searchText: String?

	override init(frame: CGRect) {
		super.init(frame: frame)
		let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, noResultImageView])
		stack.axis = .vertical
		stack.alignment = .center

		addSubview(stack)
		stack.centerX(inView: self)
		stack.centerY(inView: self, yConstant: 80)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

