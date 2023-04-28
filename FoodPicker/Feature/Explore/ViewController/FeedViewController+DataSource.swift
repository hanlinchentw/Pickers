//
//  FeedViewController+DataSource.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/27.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit

extension FeedViewController {
	typealias DataSource = UICollectionViewDiffableDataSource<Section, RestaurantViewObject>
	typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, RestaurantViewObject>
	
	enum Section {
		case result
	}
	
	func makeDataSource() -> DataSource {
		let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, RestaurantViewObject> { cell, indexPath, item in
			var content = cell.defaultContentConfiguration()
			content.text = item.name
			cell.indentationLevel = 2
			cell.contentConfiguration = content
		}
		
		let dataSource = UICollectionViewDiffableDataSource<Section, RestaurantViewObject>(collectionView: collectionView) { collectionView, indexPath, restaurant in
			let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: restaurant)
			return cell
		}
		
		return dataSource
	}
	
	func applyDataSource() {
		var snapshot = DataSourceSnapshot()
		snapshot.appendSections([.result])
		snapshot.appendItems([.init(name: "Louisa"), .init(name: "Louisa"), .init(name: "Louisa")])
		dataSource.apply(snapshot, animatingDifferences: true)
	}
}
