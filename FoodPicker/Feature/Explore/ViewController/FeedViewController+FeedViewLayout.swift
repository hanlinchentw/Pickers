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
		collectionView.showsVerticalScrollIndicator = false
		collectionView.register(FeedCell.self, forCellWithReuseIdentifier: NSStringFromClass(FeedCell.self))
		view.addSubview(collectionView)
		collectionView.fit(inView: view)
	}

	class FeedViewLayout: UICollectionViewCompositionalLayout {

		init() {
			super.init { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
				let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(350))
				let item = NSCollectionLayoutItem(layoutSize: itemSize)
				item.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 24)
				let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, repeatingSubitem: item, count: 1)
				let section = NSCollectionLayoutSection(group: group)
				section.interGroupSpacing = 32
				section.contentInsets = .init(top: 0, leading: 0, bottom: 120, trailing: 0)
				return section
			}
		}

		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}
}
