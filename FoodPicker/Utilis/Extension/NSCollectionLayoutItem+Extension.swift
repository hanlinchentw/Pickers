//
//  NSCollectionLayoutItem+Extension.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/10/12.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit

extension NSCollectionLayoutItem {
	static func create(widthFraction: CGFloat, heightFraction: CGFloat) -> NSCollectionLayoutItem {
		return NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(widthFraction),
				heightDimension: .fractionalHeight(heightFraction)
			)
		)
	}
}
