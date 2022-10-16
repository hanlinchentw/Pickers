//
//  RestaurantsList.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/9/24.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

private let restaurantListCellIdentifier = "listCellIdentifier"

protocol RestaurantsListDelegate: AnyObject {
  func didTapActionButton(_ restaurant: RestaurantViewObject, indexPath: IndexPath)
	func didTapAddButton()
}

class RestaurantsList: UICollectionView {
  //MARK: - Properties
  var restaurants = [RestaurantViewObject]() { didSet { self.reloadData() }}
  weak var listDelegate: RestaurantsListDelegate?
  //MARK: - Lifecycle
	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = .init(width: UIScreen.screenWidth, height: 93 + 24)
		super.init(frame: frame, collectionViewLayout: layout)
		layer.cornerRadius = 16
		backgroundColor = .white
		delegate = self
		dataSource = self
		register(RestaurantListCell.self, forCellWithReuseIdentifier: restaurantListCellIdentifier)
		register(RestaurantListFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(RestaurantListFooterView.self))
	}

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension RestaurantsList: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return restaurants.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = self.dequeueReusableCell(withReuseIdentifier: restaurantListCellIdentifier, for: indexPath) as! RestaurantListCell
		let restaurant = restaurants[indexPath.row]
		let actionButtonMode: ActionButtonMode = restaurant.isSelected ? .select : .deselect
		cell.presenter = RestaurantPresenter(restaurant: restaurant, actionButtonMode: actionButtonMode)
		cell.delegate = self
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		if kind == UICollectionView.elementKindSectionFooter {
			let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(RestaurantListFooterView.self), for: indexPath) as! RestaurantListFooterView
			footer.didTap = { [weak self] in
				self?.listDelegate?.didTapAddButton()
			}
			return footer
		}
		return UICollectionReusableView()
	}
}
// MARK: - UICollectionViewDelegateFlowLayout
extension RestaurantsList: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		return .init(width: UIScreen.screenWidth, height: 72)
	}
}
// MARK: - RestaurantListCellDelegate
extension RestaurantsList: RestaurantListCellDelegate {
  func didTapActionButton(_ restaurant: RestaurantViewObject) {
    let index = restaurants.firstIndex(where: { $0.id == restaurant.id })!
    listDelegate?.didTapActionButton(restaurant, indexPath: .init(row: index, section: 0))
  }
}
