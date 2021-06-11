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
    
    private let location = LocationHandler.shared.locationManager.location?.coordinate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let mapVC = MapViewController()
    private let categoryVC : CategoriesViewController = {
        let cv = CategoriesViewController(collectionViewLayout: UICollectionViewFlowLayout())
        return cv
    }()
    
    let defaultOptions : [recommendOption] = [.popular, .topPick]
    private var dataSource = [Restaurant]()
    private var topPicksDataSource = [Restaurant]()
    private var popularDataSource = [Restaurant]()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        preloadData()
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
        let group = DispatchGroup()
        self.categoryVC.showSpinner()
        let concurrentQueue: DispatchQueue = DispatchQueue(label: "CorrentQueue", attributes: .concurrent)
        group.enter()
        concurrentQueue.async(group:group) {
            self.preload(by: .topPick, numOfRestaurant: 6)
            group.leave()
        }
        group.enter()
        concurrentQueue.async(group:group) {
            self.preload(by: .popular, numOfRestaurant: 6)
            group.leave()
        }
        group.enter()
        concurrentQueue.async(group:group) {
            self.preload(by: .all, numOfRestaurant: 20)
            group.leave()

        }
        group.notify(queue: DispatchQueue.main) {
            print("DEBUG: Already downloaded all the data ")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                self.categoryVC.removeSpinner()
            }
        }
    }
    fileprivate func preload(by option: recommendOption, numOfRestaurant: Int) {
        print("DEBUG: Preload data ... Main page")
        self.retry(5) { success, failure in
            self.fetchRestaurants(by: option, limit: numOfRestaurant, success: success, failure: failure)
        } success: {
            print("DEBUG: Successfully load data ... main page  ")
            switch option {
            case .all:
                self.categoryVC.dataSource = self.dataSource
                self.mapVC.restaurants = self.dataSource
                self.isDataLoadedSuccessfully(true)
            case .topPick:
                self.categoryVC.topPicksDataSource = self.topPicksDataSource
                self.isDataLoadedSuccessfully(true)
            case .popular:
                self.categoryVC.popularDataSource = self.popularDataSource
                self.isDataLoadedSuccessfully(true)
            }
        } failure: { error in
            print("DEBUG: Failed to load \(option.description) category section.  \(error.localizedDescription)")
            self.isDataLoadedSuccessfully(false)
        }
    }

    fileprivate func fetchRestaurants(by option: recommendOption, limit: Int, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        guard let location = location else { return }
        self.fetchRestaurantsByOption(location: location, option: option, limit: limit) { (result, error) in
            print("DEBUG: Fetching data ... main VC ")
            if let result = result {
                self.restaurantCheckProcess(restaurants: result) { checkedRestaurants in
                    switch option {
                    case .all:
                        self.dataSource = checkedRestaurants
                    case .popular:
                        self.popularDataSource = checkedRestaurants
                    case .topPick:
                        self.topPicksDataSource = checkedRestaurants
                    }
                }
                success()
            }else {
                failure(error!)
            }
        }
    }
    
    func restaurantCheckProcess(restaurants: [Restaurant], completion: @escaping([Restaurant])->Void) {
        var uncheckedRestaurants = restaurants
        for (index, item) in uncheckedRestaurants.enumerated(){
            self.checkIfUserLiked(context: self.context, uncheckedRestaurant: item) { (isLiked) in
                uncheckedRestaurants[index].isLiked = isLiked
                completion(uncheckedRestaurants)
            }
        }
    }

    func updateSelectedRestaurantsInCoredata(restaurant: Restaurant){
        guard let tab = tabBarController as? HomeController else { return }
        do{
            try tab.updateSelectedRestaurants(from: self, restaurant: restaurant)
            self.categoryVC.updateSelectStatus(restaurantID: restaurant.restaurantID)
            updateSelectedRestaurantsInCoredata(context: context, restaurant: restaurant)
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
                            paddingTop: 0, paddingBottom: 80)
    }
    func isDataLoadedSuccessfully(_ isSuccess: Bool){
        if isSuccess {
            self.categoryVC.collectionView.isHidden = false
            self.categoryVC.errorView?.removeFromSuperview()
        }else{
            self.categoryVC.configureErrorView()
            self.categoryVC.collectionView.isHidden = true
        }
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
    func didTapCategoryCard(textOnCard text: String) {
        guard let tab = tabBarController as? HomeController else { return }
        tab.searchRestaurantsFromCategoryCard(textOnCard: text)
    }
    
    func pushToDetailVC(_ restaurant: Restaurant) {
        self.categoryVC.collectionView.isUserInteractionEnabled = false
        self.categoryVC.showSpinner()
        let detailVC = DetailController(restaurant: restaurant)
        self.retry(3) { success, failure in
            detailVC.fetchDetail(success: success, failure: failure)
        } success: {
            detailVC.delegate = self
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.navigationController?.navigationBar.barStyle = .black
                self.navigationController?.pushViewController(detailVC, animated: true)
                self.categoryVC.collectionView.isUserInteractionEnabled = true
                self.categoryVC.removeSpinner()
            }
        } failure: { error in
            print("DEBUG: Failed to push to detail VC ... ")
            let alert = UIAlertController(title: "Internet Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            self.categoryVC.collectionView.isUserInteractionEnabled = true
            self.categoryVC.removeSpinner()
        }
    }
    func didSelectRestaurant(restaurant: Restaurant) {
        updateSelectedRestaurantsInCoredata(restaurant: restaurant)
    }
    func didLikeRestaurant(restaurant: Restaurant) {
        self.categoryVC.updateLikeRestaurant(restaurantID: restaurant.restaurantID)
        updateLikedRestaurantsInDataBase(context: context, restaurant: restaurant)
    }
    func reloadData() {
        self.preloadData()
    }
}
//MARK: - DetailControllerDelegate
extension MainPageController: DetailControllerDelegate {
    func updateLikedRestaurant(restaurant: Restaurant) {
        self.categoryVC.updateLikeRestaurant(restaurantID: restaurant.restaurantID)
        updateLikedRestaurantsInDataBase(context: context, restaurant: restaurant)
    }
    
    func updateSelectedRestaurant(restaurant: Restaurant) {
        updateSelectedRestaurantsInCoredata(restaurant: restaurant)
    }
    func willPopViewController(_ controller: DetailController) {
        controller.navigationController?.popViewController(animated: true)
    }
}
