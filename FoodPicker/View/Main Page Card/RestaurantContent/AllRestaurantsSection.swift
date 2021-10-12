//
//  AllRestaurantsSection.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/9/1.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
private let restaurantsListIdentifier = "ListCell"

protocol AllRestaurantsSectionDelegate: AnyObject {
    func didSelectRestaurant(restaurant:Restaurant)
    func didTapRestaurant(restaurant:Restaurant)
    func shouldSeeAllRestaurants(restaurants:[Restaurant])
}
class AllRestaurantsSection: UICollectionReusableView{
    //MARK: - Properties
    var restaurants = [Restaurant]() { didSet { self.tableView.restaurants = self.restaurants } }
    weak var delegate : AllRestaurantsSectionDelegate?
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "All Restaurants"
        label.textColor = .black
        label.font = UIFont(name: "Avenir-Heavy", size: 24)
        return label
    }()
    
    private let tableView = RestaurantsList()
    
    private lazy var footerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        let label = UILabel()
        label.text = "See All Restaurants"
        label.font = UIFont.arialBoldMT
        label.textColor = .black
        view.addSubview(label)
        label.center(inView: view)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SeeMoreRestaurants))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        
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
    deinit {
        print("DEBUG: Release")
    }
    //MARK: - Helpers
    func configureUI(){
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 24, height: 36)
        configureTableview()
    }
    func configureTableview(){
        tableView.delegate = self
        tableView.listDelegate = self
        tableView.config = .sheet
        tableView.register(RestaurantListCell.self, forCellReuseIdentifier: restaurantsListIdentifier)

        addSubview(tableView)
        tableView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor,
                              right: rightAnchor,bottom: bottomAnchor)
        
        addSubview(footerView)
        footerView.anchor(left:tableView.leftAnchor, right: tableView.rightAnchor, bottom: tableView.bottomAnchor,
                          paddingLeft: 32, paddingRight: 32, paddingBottom: 24,
                          height: 48)
        footerView.centerX(inView: self)
    }
    //MARK: - Seletors
    @objc func SeeMoreRestaurants(){
        delegate?.shouldSeeAllRestaurants(restaurants: self.restaurants)
    }
}
//MARK: - UITableViewDelegate
extension AllRestaurantsSection: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         delegate?.didTapRestaurant(restaurant: restaurants[indexPath.row])
    }
}
//MARK: - RestaurantListCellDelegate
extension AllRestaurantsSection: RestaurantsListDelegate{
    func didSelectRestaurant(_ restaurant: Restaurant){
        delegate?.didSelectRestaurant(restaurant: restaurant)
    }
}
