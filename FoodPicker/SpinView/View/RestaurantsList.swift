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
  func didTapActionButton(_ restaurant: Restaurant)
}

class RestaurantsList: UITableView{
  //MARK: - Properties
  var restaurants = [Restaurant]() { didSet { self.reloadData() }}
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
}

// MARK: - RestaurantListCellDelegate
extension RestaurantsList: RestaurantListCellDelegate {
  func didTapActionButton(_ restaurant: Restaurant) {
    listDelegate?.didTapActionButton(restaurant)
  }
}
