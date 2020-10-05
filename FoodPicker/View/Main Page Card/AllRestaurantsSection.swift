//
//  AllRestaurantsSection.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/9/1.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
private let restaurantsListIdentifier = "ListCell"

protocol AllRestaurantsSectionDelegate:class {
    func didSelectRestaurant(restaurant:Restaurant)
    func didTapRestaurant(restaurant:Restaurant)
}
class AllRestaurantsSection: UICollectionReusableView{
    //MARK: - Properties
    var restaurants = [Restaurant]() { didSet { tableView.reloadData()} }
    weak var delegate : AllRestaurantsSectionDelegate?
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "All Restaurants"
        label.font = UIFont(name: "Avenir-Heavy", size: 24)
        return label
    }()
    
    private let tableView = UITableView()
    
    private let footerView : UIView = {
        let view = UIView()
        view.backgroundColor = .customblack
        view.layer.cornerRadius = 12
        let label = UILabel()
        label.text = "See All Restaurants"
        label.font = UIFont.arialBoldMT
        label.textColor = .white
        view.addSubview(label)
        label.center(inView: view)
        return view
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame:frame)
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    func configureUI(){
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 24, height: 36)
        
        configureTableview()
    }
    func configureTableview(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.rowHeight = 88 + 16
        tableView.layer.cornerRadius = 16
        
        
        addSubview(tableView)
        tableView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor,
                              right: rightAnchor,bottom: bottomAnchor,
                              paddingTop: 0)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        tableView.register(RestaurantListCell.self, forCellReuseIdentifier: restaurantsListIdentifier)
        
        addSubview(footerView)
        footerView.anchor(bottom: tableView.bottomAnchor, paddingBottom: 16, width: 336, height: 48)
        footerView.centerX(inView: self)
    }
}

extension AllRestaurantsSection: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: restaurantsListIdentifier, for: indexPath)
        as! RestaurantListCell
        cell.viewModel = CardCellViewModel(restaurant: restaurants[indexPath.row])
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         delegate?.didTapRestaurant(restaurant: restaurants[indexPath.row])
    }
}
extension AllRestaurantsSection: RestaurantListCellDelegate{
    func didSelectRestaurant(_ restaurant: Restaurant) {
        delegate?.didSelectRestaurant(restaurant: restaurant)
    }
}
