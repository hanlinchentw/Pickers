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
import CoreData

// Collection view identifiers
private let foodCardSection = "FoodCardCell"
private let headerCell = "SortHeader"
private let footerCell = "AllRestaurantsSection"

// This controller contains two view contrller, CategoryViewController and mapViewController.
class MainPageController: UIViewController, MBProgressHUDProtocol, CoredataOperation {
  //MARK: - Properties
  private let navBarView = MainPageNavigationBar()

  private let location = LocationHandler.shared.locationManager.location?.coordinate
  internal let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  private let mapVC = MapViewController()
  private let categoryVC : CategoriesViewController = {
    let cv = CategoriesViewController(collectionViewLayout: UICollectionViewFlowLayout())
    return cv
  }()

  let defaultOptions : [recommendOption] = [.popular, .topPick]
  internal var restaurants : RestaurantsFiltered?
  private var topPicksDataSource : RestaurantsFiltered?
  private var popularDataSource : RestaurantsFiltered?
  private var errorView: ErrorView?
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    loadData()
    configureMapView()
    configureNavBar()
    configureCategoryView()
    observeEntityChange()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navBarSetUp()
  }
  //MARK: -API
  func loadData(){
    let group = DispatchGroup()
    self.showLoadingAnimation()
    fetchRestaurantsRetryWhenFailed(by: .all, numOfRestaurant: 10)
    fetchRestaurantsRetryWhenFailed(by: .popular, numOfRestaurant: 6)
    fetchRestaurantsRetryWhenFailed(by: .topPick, numOfRestaurant: 6)
  }
  fileprivate func fetchRestaurantsRetryWhenFailed(by option: recommendOption, numOfRestaurant: Int) {
    self.retry(3) { success, failure in
      self.fetchRestaurants(by: option, limit: numOfRestaurant,
                            success: success,
                            failure: failure)
    } success: { [weak self] in
      self?.updateCategoryData()
      self?.categoryVC.calculatTheSectionNumber()
      self?.isDataLoadedSuccessfully(true)
    } failure: { error in
      if self.restaurants == nil,
         self.popularDataSource == nil,
         self.topPicksDataSource == nil{
        self.isDataLoadedSuccessfully(false)
      }
    }
  }
  fileprivate func fetchRestaurants(by option: recommendOption, limit: Int,
                                    success: @escaping () -> Void,
                                    failure: @escaping (Error) -> Void) {
    guard let location = location else {
      failure(URLRequestFailureResult.clientFailure)
      return
    }
    self.fetchRestaurantsByOption(location: location, option: option, limit: limit) { (result, error) in
      if let result = result, !result.isEmpty {
        self.restaurantsLikeStatusCheck(restaurants: result) { checkedRestaurants in
          switch option {
          case .all:
            self.restaurants = RestaurantsFiltered(restaurants: checkedRestaurants, filterOption: .all)
          case .popular:
            self.popularDataSource = RestaurantsFiltered(restaurants: checkedRestaurants, filterOption: .popular)
          case .topPick:
            self.topPicksDataSource = RestaurantsFiltered(restaurants: checkedRestaurants, filterOption: .topPick)
          }
        }
        success()
      }else {
        failure(error!)
      }
    }
  }
  func isDataLoadedSuccessfully(_ isSuccess: Bool){
    if isSuccess {
      if errorView != nil {
        self.errorView?.removeFromSuperview()
        self.errorView = nil
      }
      self.categoryVC.collectionView.isHidden = false
      self.hideLoadingAnimation()
    }else{
      self.errorView?.removeFromSuperview()
      errorView = ErrorView()
      errorView?.delegate = self
      if errorView != nil {
        self.view.addSubview(errorView!)
        self.categoryVC.collectionView.isHidden = true
      }
      self.hideLoadingAnimation()
    }
  }
  func updateCategoryData(){
    if let allRestaurants = self.restaurants {
      self.categoryVC.dataSource.restaurants = allRestaurants.prefix(to: 10)
    };if let popularRestaurants = self.popularDataSource {
      self.categoryVC.popularDataSource = popularRestaurants
    };if let topPickRestaurants = self.topPicksDataSource {
      self.categoryVC.topPicksDataSource = topPickRestaurants
    }
  }
}
//MARK: - Observe entity change
extension MainPageController {
  func observeEntityChange(){
    NotificationCenter.default.addObserver(self, selector: #selector(contextDidChange), name: NSManagedObjectContext.didSaveObjectsNotification, object: context)
  }
  @objc func contextDidChange(_ notification: NSNotification){
    guard let userInfo = notification.userInfo else { return }

    if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
       inserts.count > 0 {
      let insertedObject = inserts.first
      print("DEBUG: Select restaurant \(insertedObject)")
      if let selected = insertedObject as? SelectedRestaurant , let id = selected.id{
        self.categoryVC.updateSelectStatus(restaurantID: id, shouldSelect: true)
        self.mapVC.updateSelectStatus(restaurantID: id, shouldSelect: true)
      }else if let liked = insertedObject as? LikedRestaurant, let id = liked.id {
        self.categoryVC.updateLikeRestaurant(restaurantID: id, shouldLike: true)
        self.mapVC.updateLikeRestaurant(restaurantID: id, shouldLike: true)
      }
    }
    if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> ,
       deletes.count > 0 {
      let deleteObject = deletes.first
      if let selected = deleteObject as? SelectedRestaurant , let id = selected.id{
        self.categoryVC.updateSelectStatus(restaurantID: id, shouldSelect: false)
        self.mapVC.updateSelectStatus(restaurantID: id, shouldSelect: false)
      }else if let liked = deleteObject as? LikedRestaurant, let id = liked.id {
        self.categoryVC.updateLikeRestaurant(restaurantID: id, shouldLike: false)
        self.mapVC.updateLikeRestaurant(restaurantID: id, shouldLike: false)
      }
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
extension MainPageController: MainPageChildControllersDelegate{
  func didTapCategoryCard(textOnCard text: String) {
    guard let tab = tabBarController as? HomeController else { return }
    tab.searchRestaurantsFromCategoryCard(textOnCard: text)
  }
  func pushToDetailVC(_ restaurant: Restaurant) {
    self.categoryVC.collectionView.isUserInteractionEnabled = false
    self.categoryVC.showLoadingAnimation()
    let detailVC = DetailController(restaurant: restaurant)
    self.retry(3) { success, failure in
      detailVC.fetchDetail(success: success, failure: failure)
    } success: {
      detailVC.delegate = self
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.pushViewController(detailVC, animated: true)
        self.categoryVC.collectionView.isUserInteractionEnabled = true
        self.categoryVC.hideLoadingAnimation()
      }
    } failure: { _ in
      self.presentPopupViewWithoutButton(title: "Sorry..",
                                         subtitle: "Please check you internet connection")
      self.categoryVC.collectionView.isUserInteractionEnabled = true
      self.categoryVC.hideLoadingAnimation()
    }
  }
  func didSelectRestaurant(restaurant: Restaurant) {
    updateSelectedRestaurantsInCoredata(context: context, restaurant: restaurant)
  }
  func didLikeRestaurant(restaurant: Restaurant) {
    updateLikedRestaurantsInDataBase(context: context, restaurant: restaurant)
  }
}

//MARK: - DetailControllerDelegate
extension MainPageController: DetailControllerDelegate {
  func willPopViewController(_ controller: DetailController) {
    controller.navigationController?.popViewController(animated: true)
  }
}
//MARK: - ErrorViewDelegate
extension MainPageController: ErrorViewDelegate {
  func didTapReloadButton() {
    self.loadData()
  }
}
//MARK: - Autolayout {
extension MainPageController {
  func navBarSetUp(){
    navigationController?.navigationBar.barStyle = .default
    navigationController?.navigationBar.isHidden = true
    navigationController?.navigationBar.isTranslucent = true
    tabBarController?.tabBar.isHidden = false
    tabBarController?.tabBar.isTranslucent = true
  }
  func configureNavBar(){
    navBarView.delegate = self
    view.addSubview(navBarView)
    let heightMultiplier = UIScreen.main.bounds.height / CGFloat(896)
    let height = heightMultiplier * 98
    navBarView.anchor(top: view.topAnchor, left: view.leftAnchor,
                      right: view.rightAnchor, height: height)

  }
  func configureCategoryView(){
    guard let categoryView = categoryVC.view else { return }
    categoryVC.delegate = self
    self.addChild(categoryVC)
    view.insertSubview(categoryView, at: 1)
    categoryView.isHidden = false
    categoryView.anchor(top: navBarView.bottomAnchor,left: view.leftAnchor,
                        right: view.rightAnchor, bottom: view.bottomAnchor)
  }

  func configureMapView(){
    guard let map = mapVC.view else { return }
    mapVC.delegate = self
    self.addChild(mapVC)
    view.insertSubview(map, at: 2)
    map.isHidden = true
  }
}
