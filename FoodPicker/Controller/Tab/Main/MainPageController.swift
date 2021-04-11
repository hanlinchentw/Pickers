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
import CoreData

// Some Collection view identifiers
private let foodCardSection = "FoodCardCell"
private let headerCell = "SortHeader"
private let footerCell = "AllRestaurantsSection"

// This controller contains two view contrller, Category view controller and map view controller.
class MainPageController: UIViewController, MapViewControllerDelegate {
    //MARK: - Properties
    private let navBarView = MainPageNavigationBar()
    
    private let locationManager = LocationHandler.shared.locationManager
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
            self.fetchRestaurantsByOption(limit: 10) { (restaurants) in
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
    func fetchRestaurantsByOption(option: recommendOption? = nil, limit: Int, offset: Int = 0 ,completion: @escaping([Restaurant])-> Void) {
        guard let location = locationManager.location?.coordinate else { return  }
        NetworkService.shared
            .fetchRestaurants(lat: location.latitude, lon: location.longitude, withOffset: offset, option: option,limit: limit)
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
        let connect = CoredataConnect(context: context)
        connect.checkIfRestaurantIsIn(entity: likedEntityName, id: uncheckedRestaurant.restaurantID) { (isLiked) in
            completion(isLiked)
        }
    }
    func updateSelectedRestaurantsInCoredata(restaurant: Restaurant){
        guard let tab = tabBarController as? HomeController else { return }
        do{
            try tab.updateSelectedRestaurants(from: self, restaurant: restaurant)
            self.categoryVC.updateSelectStatus(restaurantID: restaurant.restaurantID)
            let connect = CoredataConnect(context: context)
            connect.checkIfRestaurantIsIn(entity: selectedEntityName, id: restaurant.restaurantID) { (isSelected) in
                if isSelected{
                    connect.deleteRestaurantIn(entityName: selectedEntityName, id: restaurant.restaurantID)
                }else{
                    connect.saveRestaurantInLocal(restaurant: restaurant, entityName: selectedEntityName,
                                                  trueForSelectFalseForLike: true)
                }
            }
        }catch SelectRestaurantResult.upToLimit{
            let alert = UIAlertController(title: "Sorry! you can only select 8 restaurant. 😢", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
                self.mapVC.collecionView.reloadData()
                self.categoryVC.collectionView.reloadData()
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }catch{
            print("DEBUG: Failed to select restaurant.")
        }
    }
    func updateLikedRestaurantsInDataBase(restaurant:Restaurant){
        RestaurantService.shared.updateLikedRestaurant(restaurant: restaurant, shouldLike: !restaurant.isLiked)
        self.categoryVC.updateLikeRestaurant(restaurantID: restaurant.restaurantID)
        let connect = CoredataConnect(context: context)
        connect.checkIfRestaurantIsIn(entity: likedEntityName, id: restaurant.restaurantID) { (isLiked) in
            if isLiked{
                connect.deleteRestaurantIn(entityName: likedEntityName, id: restaurant.restaurantID)
            }else{
                connect.saveRestaurantInLocal(restaurant: restaurant, entityName: likedEntityName,
                                              trueForSelectFalseForLike: false)
            }
        }
    }
    //MARK: - Helpers
    func configureUI(){
        guard let map = mapVC.view else { return }
        mapVC.delegate = self
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
        mapVC.checkBeforeRestaurantLoaded(completion: nil)
    }
}
//MARK: - CategoriesViewControllerDelegate
extension MainPageController: CategoriesViewControllerDelegate{
    func pushToDetailVC(_ restaurant: Restaurant) {
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
    func didSelectRestaurant(restaurant: Restaurant) {
        updateSelectedRestaurantsInCoredata(restaurant: restaurant)
    }
    func didLikeRestaurant(restaurant: Restaurant) {
        updateLikedRestaurantsInDataBase(restaurant: restaurant)
    }
}
//MARK: - DetailControllerDelegate
extension MainPageController: DetailControllerDelegate {
    func updateLikedRestaurant(restaurant: Restaurant) {
        updateLikedRestaurantsInDataBase(restaurant: restaurant)
    }
    
    func updateSelectedRestaurant(restaurant: Restaurant) {
        updateSelectedRestaurantsInCoredata(restaurant: restaurant)
    }
    func willPopViewController(_ controller: DetailController) {
        controller.navigationController?.popViewController(animated: true)
    }
}
