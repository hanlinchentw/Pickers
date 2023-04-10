//
//  StrechyHeaderLayout.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/10/1.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit

class StrechyHeaderLayout: UICollectionViewFlowLayout {
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		let layoutAttrubutes = super.layoutAttributesForElements(in: rect)
		layoutAttrubutes?.forEach({ attr in
			guard let collectionView = collectionView else {
				return
			}
			
			if attr.representedElementKind == UICollectionView.elementKindSectionHeader {
				let offset = collectionView.contentOffset.y
				if offset > 0 { return }
				let width = collectionView.frame.width
				let height = attr.frame.height - offset
				attr.frame = CGRect(x: 0, y: offset, width: width, height: height)
			}
		})
		return layoutAttrubutes
	}
	
	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}
}
