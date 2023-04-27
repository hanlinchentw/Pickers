//
//  FeedViewController+DataSource.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/27.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit

extension FeedViewController {
	enum RestaurantSection {
		case popular
		case nearby
	}
	
	func makeDataSource() -> UICollectionViewDiffableDataSource<RestaurantSection, RestaurantViewObject> {
		
		let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionReusableView>(elementKind: UICollectionView.elementKindSectionHeader) { headerView, elementKind, indexPath in
			headerView.backgroundColor = .systemBackground
			let label = UILabel()
			label.text = indexPath.section == 0 ? "Popular" : "Nearyby"
			label.font = UIFont.boldSystemFont(ofSize: 20)
			headerView.addSubview(label)
			label.snp.makeConstraints { make in
				make.edges.equalToSuperview()
			}
		}
		
		let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, RestaurantViewObject> { cell, indexPath, item in
			var content = cell.defaultContentConfiguration()
			content.text = item.name
			cell.indentationLevel = 2
			cell.contentConfiguration = content
		}
		
		let dataSource = UICollectionViewDiffableDataSource<RestaurantSection, RestaurantViewObject>(collectionView: collectionView) { collectionView, indexPath, restaurant in
			let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: restaurant)
			return cell
		}

		dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
			collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
		}
		
		return dataSource
	}
	
	func applyDataSource() {
		let popularRestaurants: [RestaurantViewObject] = [.init(name: "Louisa"), .init(name: "Louisa"), .init(name: "Louisa")]
		let nearbyRestaurants: [RestaurantViewObject] = [.init(name: "Louisa"), .init(name: "Louisa"), .init(name: "Louisa"), .init(name: "Louisa")]
		
		var restaurantData = [RestaurantSection: [RestaurantViewObject]]()
		restaurantData[.popular] = popularRestaurants
		restaurantData[.nearby] = nearbyRestaurants
		
		var snapshot = NSDiffableDataSourceSnapshot<RestaurantSection, RestaurantViewObject>()
		snapshot.appendSections([.popular, .nearby])
		snapshot.appendItems(restaurantData[.popular] ?? [], toSection: .popular)
		snapshot.appendItems(restaurantData[.nearby] ?? [], toSection: .nearby)
		dataSource.apply(snapshot, animatingDifferences: true)
	}
}
