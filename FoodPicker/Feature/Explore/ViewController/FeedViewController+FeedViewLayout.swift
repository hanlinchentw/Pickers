//
//  FeedViewController+Layout.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/26.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit

extension FeedViewController {

	func setupCollectionView() {
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: FeedViewLayout())
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(FeedCell.self, forCellWithReuseIdentifier: NSStringFromClass(FeedCell.self))
		view.addSubview(collectionView)
		collectionView.fit(inView: view)
	}

	class FeedViewLayout: UICollectionViewCompositionalLayout {

		init() {
			super.init { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
				// Define item size and group for vertical section
				let verticalItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(350))
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
