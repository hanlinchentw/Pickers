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

class RestaurantsList: UITableView{
  //MARK: - Properties
  var restaurants = [RestaurantViewObject]() { didSet {
		UIView.performWithoutAnimation {
			self.reloadDataSmoothly()
		}		
	}}

	private lazy var addButton: UIButton = {
		let btn = UIButton(type: .system)
		btn.addTarget(self, action: #selector(handleAddButtonTapped), for: .touchUpInside)
		btn.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
		btn.tintColor = .butterscotch
		return btn
	}()
	
  weak var listDelegate: RestaurantsListDelegate?
  //MARK: - Lifecycle
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: .plain)
    layer.cornerRadius = 16
    rowHeight = 93 + 24
    backgroundColor = .white
    separatorStyle = .none
    delegate = self
    dataSource = self

    register(RestaurantListCell.self, forCellReuseIdentifier: restaurantListCellIdentifier)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
	
	@objc func handleAddButtonTapped() {
		listDelegate?.didTapAddButton()
	}
}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension RestaurantsList: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return restaurants.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.dequeueReusableCell(withIdentifier: restaurantListCellIdentifier, for: indexPath) as! RestaurantListCell
    cell.selectionStyle = .none
    let restaurant = restaurants[indexPath.row]
    let actionButtonMode: ActionButtonMode = restaurant.isSelected ? .select : .deselect
    cell.presenter = RestaurantPresenter(restaurant: restaurant, actionButtonMode: actionButtonMode)
    cell.delegate = self
    return cell
  }
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let footerView = UIView()
		footerView.addSubview(addButton)
		addButton.center(inView: footerView)
		addButton.setDimension(width: 36, height: 36)
		return footerView
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 64
	}
}

// MARK: - RestaurantListCellDelegate
extension RestaurantsList: RestaurantListCellDelegate {
  func didTapActionButton(_ restaurant: RestaurantViewObject) {
    let index = restaurants.firstIndex(where: { $0.id == restaurant.id })!
    listDelegate?.didTapActionButton(restaurant, indexPath: .init(row: index, section: 0))
  }
}
