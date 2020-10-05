//
//  RestaurantsList.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/9/24.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

private let restaurantListCellIdentifier = "listCellIdentifier"
class RestaurantsList: UITableView{
    //MARK: - Properties
    var restaurants = [Restaurant]() { didSet { self.reloadData() } }
    //MARK: - Lifecycle
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .grouped)
        layer.cornerRadius = 16
        rowHeight = 88 + 16
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
extension RestaurantsList: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: restaurantListCellIdentifier, for: indexPath)
        as! RestaurantListCell
        if restaurants.count == 0 {
            cell.viewModel = nil
        }else {
            let viewModel = CardCellViewModel(restaurant: self.restaurants[indexPath.row])
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                cell.viewModel = viewModel
            }
        }
        return cell
    }
}
