//
//  ListViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/11/8.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

private let listIdentifier = "ListIdentifier"

protocol ListViewControllerDelegate:class {
    func willPopViewController(_ controller: MoreRestaurantViewController)
}

class MoreRestaurantViewController: UIViewController {
    //MARK: - Properties
    var restaurants: [Restaurant]
    var selectedRestaurants = [Restaurant]()
    weak var delegate: ListViewControllerDelegate?
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icnArrowBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 12
        button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 56, height: 40)
        return button
    }()
    
    private let tableView = RestaurantsList()
    //MARK: - Lifecycle
    init(restaurants: [Restaurant]) {
        self.restaurants = restaurants
        self.tableView.restaurants = restaurants
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        configureNavBar()
    }
    //MARK: - Helpers
    func configureNavBar(){
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.isHidden = false
        navBar.shadowImage = UIImage()
        navBar.barTintColor = .backgroundColor
        navBar.isTranslucent = true
        let division = self.restaurants[0].division
        navigationItem.title = division.description
    
        let backButtonView = UIView(frame: CGRect(x: 0, y: 0, width: 56, height: 40))
        backButtonView.bounds = backButtonView.bounds.offsetBy(dx: 18, dy: 0)
        backButtonView.addSubview(backButton)
        let leftBarItem = UIBarButtonItem(customView: backButtonView)
        navigationItem.leftBarButtonItem = leftBarItem
    }
    func configureUI(){
        view.backgroundColor = .backgroundColor
        tableView.listDelegate = self
        tableView.config = .sheet
        tableView.isScrollEnabled = true
        tableView.register(RestaurantListCell.self, forCellReuseIdentifier: listIdentifier)
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                         right: view.rightAnchor,bottom: view.bottomAnchor,
                         paddingTop: 24)
        
    }
    //MARK: - Selectors
    @objc func handleDismissal(){
        delegate?.willPopViewController(self)
    }
    //MARK: - API
    func loadData(){
        guard let location = LocationHandler.shared.locationManager.location?.coordinate else { return }
        let offset = self.restaurants.count
        var option: recommendOption? {
            switch self.restaurants[0].division {
            case "Top picks":
                return recommendOption.topPick
            case "Popular":
                return recommendOption.popular
            default:
                return nil
            }
        }
        NetworkService.shared.fetchRestaurants(lat: location.latitude, lon: location.longitude,
                                               withOffset: offset, option: option, limit: 20)
        { (restaurants) in
            guard let res = restaurants, !res.isEmpty else {
                print("DEBUG: Failed to get the restaurants ...")
                return
            }
            self.restaurants += res
        }
    }
}
//MARK: - RestaurantListCellDelegate
extension MoreRestaurantViewController: RestaurantsListDelegate{
    func loadMoreData() {
        self.loadData()
        DispatchQueue.main.async {
            self.tableView.restaurants = self.restaurants
        }
    }
    func didSelectRestaurant(_ restaurant: Restaurant) {
        if restaurant.isSelected{
            self.selectedRestaurants.append(restaurant)
        }else{
            self.selectedRestaurants = self.selectedRestaurants.filter { $0.restaurantID != restaurant.restaurantID }
        }
    }
}
