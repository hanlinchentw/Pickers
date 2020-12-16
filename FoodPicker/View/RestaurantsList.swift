//
//  RestaurantsList.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/9/24.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

private let restaurantListCellIdentifier = "listCellIdentifier"
private let loadingCellIdentifier = "LoadCell"
protocol RestaurantsListDelegate: class {
    func didSelectRestaurant(_ restaurant : Restaurant)
    func loadMoreData()
}
extension RestaurantsListDelegate{
    func loadMoreData(){}
}

class RestaurantsList: UITableView{
    //MARK: - Properties
    weak var listDelegate : RestaurantsListDelegate?
    var restaurants = [Restaurant]() { didSet { self.reloadData() }}
    var config: ListConfiguration? { didSet { self.reloadData() }}
    var isLoading: Bool? = false
    //MARK: - Lifecycle
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .plain)
        layer.cornerRadius = 16
        rowHeight = 93 + 24
        backgroundColor = .clear
        separatorStyle = .none
        delegate = self
        dataSource = self
        isScrollEnabled = false
        register(RestaurantListCell.self, forCellReuseIdentifier: restaurantListCellIdentifier)
        register(LoadingCell.self, forCellReuseIdentifier: loadingCellIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - API
    func loadMoreData(){
        if let isLoading = self.isLoading, !isLoading{
            self.isLoading = true
            DispatchQueue.global().async {
                sleep(1)
                self.listDelegate?.loadMoreData()
                self.isLoading = false
            }
        }
    }
}
extension RestaurantsList: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return restaurants.count
        }else if section == 1{
            return 1
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.dequeueReusableCell(withIdentifier: restaurantListCellIdentifier, for: indexPath)
            as! RestaurantListCell
            cell.selectionStyle = .none
            cell.delegate = self
            let viewModel = CardCellViewModel(restaurant: self.restaurants[indexPath.row])
            cell.viewModel = viewModel
            cell.config = self.config
            cell.contentView.isUserInteractionEnabled = true
            return cell
        }else{
            let cell = self.dequeueReusableCell(withIdentifier: loadingCellIdentifier, for: indexPath)
            as! LoadingCell
            if let isLoading = isLoading, isLoading { cell.indicator.startAnimating() }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
}
//MARK: - UIScrollViewDelegate
extension RestaurantsList: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let isLoading = isLoading else { return }
        let threshold : CGFloat = 55
        let offsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        if (maximumOffset - offsetY <= threshold) && !isLoading {
            loadMoreData()
        }
    }
}
extension RestaurantsList: RestaurantListCellDelegate{
    func didSelectRestaurant(_ restaurant: Restaurant) {
        listDelegate?.didSelectRestaurant(restaurant)
    }
}
