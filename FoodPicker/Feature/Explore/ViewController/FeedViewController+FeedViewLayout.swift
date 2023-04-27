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
	var horizontalItemWidth: NSCollectionLayoutDimension {
		.fractionalWidth(0.4)
	}
	
	var horizontalItemHeight: NSCollectionLayoutDimension {
		.fractionalWidth(0.2)
	}
	
	var verticalItemWidth: NSCollectionLayoutDimension {
		.fractionalWidth(1)
	}
	
	var verticalItemHeight: NSCollectionLayoutDimension {
		.absolute(100)
	}
	
	func setupCollectionView() {
		let horizontalItemSize = NSCollectionLayoutSize(widthDimension: horizontalItemWidth, heightDimension: horizontalItemHeight)
		let verticalItemSize = NSCollectionLayoutSize(widthDimension: verticalItemWidth, heightDimension: verticalItemHeight)
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: FeedViewLayout(horizontalItemSize: horizontalItemSize, verticalItemSize: verticalItemSize))
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Hello")
		collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
		collectionView.delegate = self
		collectionView.dataSource = self
		
		view.addSubview(collectionView)
		collectionView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}

	class FeedViewLayout: UICollectionViewCompositionalLayout {
		
		init(horizontalItemSize: NSCollectionLayoutSize, verticalItemSize: NSCollectionLayoutSize) {
			super.init { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
				// Define item size and group for horizontal section
				let horizontalItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
				horizontalItem.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
				let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalItemSize, subitems: [horizontalItem])
				let horizontalSection = NSCollectionLayoutSection(group: horizontalGroup)
				horizontalSection.orthogonalScrollingBehavior = .continuous
				
				// Define item size and group for vertical section
				let verticalItem = NSCollectionLayoutItem(layoutSize: verticalItemSize)
				verticalItem.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
				let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
				let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [verticalItem])
				let verticalSection = NSCollectionLayoutSection(group: verticalGroup)
				
				let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
				let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
				header.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
				horizontalSection.boundarySupplementaryItems = [header]
				verticalSection.boundarySupplementaryItems = [header]
				
				return sectionIndex == 0 ? horizontalSection : verticalSection
			}
		}
		
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}
}
