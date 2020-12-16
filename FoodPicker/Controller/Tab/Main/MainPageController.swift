//
//  MainPageController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation
import Firebase

private let foodCardSection = "FoodCardCell"
private let headerCell = "SortHeader"
private let footerCell = "AllRestaurantsSection"

class MainPageController: UIViewController {
    //MARK: - Properties
    private let navBarView = MainPageNavigationBar()
    private let locationManager = LocationHandler.shared.locationManager
    private let mapVC = MapViewController()
    private let categoryVC : CategoriesViewController = {
        let cv = CategoriesViewController(collectionViewLayout: UICollectionViewFlowLayout())
        return cv
    }()
    
    let defaultOptions : [recommendOption] = [.popular, .topPick]
    private var dataSource = [Restaurant]() {
        didSet{
            self.categoryVC.dataSource = self.dataSource
            self.mapVC.restaurants = self.dataSource
        }
    }
    private var topPicksDataSource = [Restaurant]() { didSet{ self.categoryVC.topPicksDataSource = topPicksDataSource }}
    private var popularDataSource = [Restaurant]() { didSet{ self.categoryVC.popularDataSource = popularDataSource }}
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationHandler.shared.enableLocationServices()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.isTranslucent = true
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.isTranslucent = true
    }
    //MARK: -API
    func preloadData(){
        let operation = OperationQueue()
        operation.qualityOfService = .userInitiated
        operation.addOperation {
            self.fetchRestaurantsByOption(option: .topPick, limit: 6) { (result) in
                self.restaurantCheckProcess(restaurants: result) { checkedRestaurants in
                    self.topPicksDataSource = checkedRestaurants
                }
            }
        }
        operation.addOperation {
            self.fetchRestaurantsByOption(option: .popular, limit: 6) { (result) in
                self.restaurantCheckProcess(restaurants: result) { checkedRestaurants in
                    self.popularDataSource = checkedRestaurants
                }
            }
        }
        operation.addOperation {
            self.fetchRestaurantsByOption(limit: 15) { (restaurants) in
                self.dataSource = restaurants
            }
        }
        
    }
    func restaurantCheckProcess(restaurants: [Restaurant], completion: @escaping([Restaurant])->Void) {
        var uncheckedRestaurants = restaurants
        for (index, item) in uncheckedRestaurants.enumerated(){
            self.checkIfUserLiked(uncheckedRestaurant: item) { (isLiked) in
                uncheckedRestaurants[index].isLiked = isLiked
                completion(uncheckedRestaurants)
            }
        }
    }
    func fetchRestaurantsByOption(option: recommendOption? = nil, limit: Int, completion: @escaping([Restaurant])-> Void) {
        guard let location = locationManager.location?.coordinate else { return  }
        NetworkService.shared
            .fetchRestaurants(lat: location.latitude, lon: location.longitude, option: option, limit: limit)
            { (restaurants) in
                guard let res = restaurants, !res.isEmpty else {
                    print("DEBUG: Failed to get the restaurants ...")
                    return
                }
                print("DEBUG: Loading data ...")
                completion(res)
                
        }
    }
    func checkIfUserLiked(uncheckedRestaurant: Restaurant, completion: @escaping(Bool)->Void){
        RestaurantService.shared
            .checkIfUserLikeRestaurant(restaurantID: uncheckedRestaurant.restaurantID)
            { isLiked in
                completion(isLiked)
        }
    }
    func updateLikeRestaurant(restaurant: Restaurant, shouldLike:Bool){
        RestaurantService.shared.updateLikedRestaurant(restaurant: restaurant, shouldLike: shouldLike)
    }
    //MARK: - Helpers
    func configureUI(){
        guard let map = mapVC.view else { return }
        self.addChild(mapVC)
        view.insertSubview(map, at: 1)
        map.isHidden = true
        guard let categoryView = categoryVC.view else { return }
        categoryVC.delegate = self
        self.addChild(categoryVC)
        view.insertSubview(categoryView, at: 1)
        categoryView.isHidden = false
        navBarView.delegate = self
        view.addSubview(navBarView)
        navBarView.anchor(top: view.topAnchor, left: view.leftAnchor,
                          right: view.rightAnchor, height: 104)
        categoryView.anchor(top: navBarView.bottomAnchor,left: view.leftAnchor,
                            right: view.rightAnchor, bottom: view.bottomAnchor,
                            paddingTop: 16, paddingBottom: 80)
    }
}
//MARK: - MainPageHeaderDelegate
extension MainPageController : MainPageHeaderDelegate {
    func handleHeaderGotTapped() {
        mapVC.view.isHidden.toggle()
        categoryVC.view.isHidden.toggle()
    }
}
extension MainPageController: CategoriesViewControllerDelegate{
    func pushToDetailVC(_ restaurant: Restaurant) {
        print(123)
        let detailVC = DetailController(restaurant: restaurant)
        detailVC.fetchDetail()
        detailVC.delegate = self
        self.categoryVC.collectionView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.navigationController?.navigationBar.barStyle = .black
            self.navigationController?.pushViewController(detailVC, animated: true)
            self.categoryVC.collectionView.isUserInteractionEnabled = true
        }
    }
    func didLikeRestaurant(_ restaurant: Restaurant){
        self.updateLikeRestaurant(restaurant: restaurant, shouldLike: !restaurant.isLiked)
    }
}
extension MainPageController: DetailControllerDelegate {
    func willPopViewController(_ controller: DetailController) {
        let restaurant = controller.restaurant
        updateLikeRestaurant(restaurant: restaurant, shouldLike: restaurant.isLiked)
        controller.navigationController?.popViewController(animated: true)
    }
}
