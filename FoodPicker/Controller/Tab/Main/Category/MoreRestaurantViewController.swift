//
//  ListViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/11/8.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import CoreData

private let listIdentifier = "ListIdentifier"

protocol MoreRestaurantViewControllerDelegate: AnyObject {
    func willPopViewController(_ controller: MoreRestaurantViewController)
    func didSelectRestaurantFromMore(restaurant: Restaurant)
    func didLikeRestaurantFromMore(restaurant:Restaurant)
}

class MoreRestaurantViewController: UIViewController, CoredataOperation {
    //MARK: - Properties
    weak var delegate: MoreRestaurantViewControllerDelegate?
    internal var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    let option: recommendOption
    //MARK: - Lifecycle
    init(restaurants: [Restaurant], option: recommendOption) {
        self.tableView.restaurants = restaurants
        self.option = option
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
        configureNavBar()
        tabBarController?.tabBar.isHidden = true
    }
    //MARK: - Helpers
    func configureNavBar(){
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.shadowImage = UIImage()
        navBar.barTintColor = .backgroundColor
        navBar.isTranslucent = true
        navigationItem.title = option.description
        
        let backButtonView = UIView(frame: CGRect(x: 0, y: 0, width: 56, height: 40))
        backButtonView.bounds = backButtonView.bounds.offsetBy(dx: 18, dy: 0)
        backButtonView.addSubview(backButton)
        let leftBarItem = UIBarButtonItem(customView: backButtonView)
        navigationItem.leftBarButtonItem = leftBarItem
        navBar.isHidden = false
    }
    func configureUI(){
        view.backgroundColor = .backgroundColor
        tableView.listDelegate = self
        tableView.config = .all
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
        let offset = self.tableView.restaurants.count

        NetworkService.shared.fetchRestaurants(lat: location.latitude, lon: location.longitude,
                                               withOffset: offset, option: self.option, limit: 20)
        { [weak self] (restaurants, error) in
            guard let self = self,
                let res = restaurants, !res.isEmpty else {
                print("DEBUG: Failed to get the restaurants ...")
                return
            }
            
            for (index, item) in res.enumerated(){
                self.checkIfRestaurantIsSelected(restaurant: item) { isSelected in
                    var newRestaurant = res[index]
                    newRestaurant.isSelected = isSelected
                    self.tableView.restaurants.append(newRestaurant)
                }
            }
            self.tableView.reloadData()
        }
    }
    
}
//MARK: - RestaurantListCellDelegate
extension MoreRestaurantViewController: RestaurantsListDelegate{
    func loadMoreData() {
        self.loadData()
    }
    func didSelectRestaurant(_ restaurant: Restaurant) {
        delegate?.didSelectRestaurantFromMore(restaurant: restaurant)
        if let index  = self.tableView.restaurants.firstIndex(where: { ($0.restaurantID == restaurant.restaurantID)}){
            self.tableView.restaurants[index].isSelected.toggle()
        }
    }
    func didLikeRestaurant(_ restaurant: Restaurant) {
        delegate?.didLikeRestaurantFromMore(restaurant: restaurant)
        if let index  = self.tableView.restaurants.firstIndex(where: { ($0.restaurantID == restaurant.restaurantID)}){
            self.tableView.restaurants[index].isLiked.toggle()
        }
    }
    func didTapRestaurant(restaurant:Restaurant){
        let detailVC = DetailController(restaurant: restaurant)
        self.retry(3) { success, failure in
            detailVC.fetchDetail(success: success, failure: failure)
        } success: { [weak self] in
            detailVC.delegate = self
            self?.tableView.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self?.navigationController?.pushViewController(detailVC, animated: true)
                self?.navigationController?.navigationBar.isHidden = true
                self?.navigationController?.navigationBar.barStyle = .black
                self?.tableView.isUserInteractionEnabled = true
            }
        } failure: { [weak self] error in
            self?.presentPopupViewWithoutButton(title: "Internet Error", subtitle: "Please check your internet connect.")
        }
    }
}
//MARK: - DetailControllerDelegate
extension MoreRestaurantViewController: DetailControllerDelegate{
    func didLikeRestaurant(restaurant: Restaurant) {
        delegate?.didLikeRestaurantFromMore(restaurant: restaurant)
        if let index  = self.tableView.restaurants.firstIndex(where: { ($0.restaurantID == restaurant.restaurantID)}){
            self.tableView.restaurants[index].isLiked.toggle()
        }
    }
    func didSelectRestaurant(restaurant: Restaurant) {
        delegate?.didSelectRestaurantFromMore(restaurant: restaurant)
        if let index  = self.tableView.restaurants.firstIndex(where: { ($0.restaurantID == restaurant.restaurantID)}){
            self.tableView.restaurants[index].isSelected.toggle()
        }
    }
    func willPopViewController(_ controller: DetailController) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            controller.navigationController?.popViewController(animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.navigationBar.barStyle = .default
        }
    }
}
