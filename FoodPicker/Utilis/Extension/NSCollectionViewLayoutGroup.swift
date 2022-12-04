//
//  NSCollectionViewLayoutGroup.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/10/12.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit

extension NSCollectionLayoutGroup {
	static func createHorizontalGroup(subitems: Array<NSCollectionLayoutItem>, widthFraction: CGFloat, heightFraction: CGFloat) -> NSCollectionLayoutGroup {
		return NSCollectionLayoutGroup.horizontal(
			layoutSize: .init(
				widthDimension: .fractionalWidth(widthFraction),
				heightDimension: .fractionalHeight(heightFraction)
			),
			subitems: subitems
		)
	}
	
	static func createVerticalGroup(subitems: Array<NSCollectionLayoutItem>, widthFraction: CGFloat, heightFraction: CGFloat) -> NSCollectionLayoutGroup {
		return NSCollectionLayoutGroup.vertical(
			layoutSize: .init(
				widthDimension: .fractionalWidth(widthFraction),
				heightDimension: .fractionalHeight(heightFraction)
			),
			subitems: subitems
		)
	}

	static func createSpacingEvenlyHorizontalGroup(count: Int, spacing: CGFloat = 0, widthFraction: CGFloat, heightFraction: CGFloat) -> NSCollectionLayoutGroup {
		let item = NSCollectionLayoutItem.create(widthFraction: CGFloat(1 / count), heightFraction: 1)
		item.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
		let group = NSCollectionLayoutGroup.horizontal(
			layoutSize: .init(
				widthDimension: .fractionalWidth(widthFraction),
				heightDimension: .fractionalHeight(heightFraction)
			),
			subitem: item,
			count: count
		)
		return group
	}
	
	static func createSpacingEvenlyVerticalGroup(count: Int, spacing: CGFloat = 0, widthFraction: CGFloat, heightFraction: CGFloat) -> NSCollectionLayoutGroup {
		let item = NSCollectionLayoutItem.create(widthFraction: 1, heightFraction: CGFloat(1 / count))
		item.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
		let group = NSCollectionLayoutGroup.vertical(
			layoutSize: .init(
				widthDimension: .fractionalWidth(widthFraction),
				heightDimension: .fractionalHeight(heightFraction)
			),
			subitem: item,
			count: count
		)
		return group
	}
}
