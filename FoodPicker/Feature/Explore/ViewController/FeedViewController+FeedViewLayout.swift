//
//  FeedViewController+Layout.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/26.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit
import SnapKit

extension FeedViewController {
	
	var verticalItemWidth: NSCollectionLayoutDimension {
		.fractionalWidth(1)
	}
	
	var verticalItemHeight: NSCollectionLayoutDimension {
		.absolute(100)
	}
	
	func setupCollectionView() {
		let verticalItemSize = NSCollectionLayoutSize(widthDimension: verticalItemWidth, heightDimension: verticalItemHeight)
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: FeedViewLayout(verticalItemSize: verticalItemSize))
		
		view.addSubview(collectionView)
		collectionView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
	
	class FeedViewLayout: UICollectionViewCompositionalLayout {
		
		init(verticalItemSize: NSCollectionLayoutSize) {
			super.init { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
				// Define item size and group for vertical section
				let verticalItem = NSCollectionLayoutItem(layoutSize: verticalItemSize)
				verticalItem.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
				let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
				let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [verticalItem])
				let verticalSection = NSCollectionLayoutSection(group: verticalGroup)
				
				return verticalSection
			}
		}
		
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}
}
