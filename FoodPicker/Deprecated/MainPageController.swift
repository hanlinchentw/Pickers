////
////  MainPageController.swift
////  FoodPicker
////
////  Created by 陳翰霖 on 2020/7/5.
////  Copyright © 2020 陳翰霖. All rights reserved.
////
//import UIKit
//import MapKit
//import CoreLocation
//import CoreData
//import RxSwift
//import RxCocoa
//
//// Collection view identifiers
//private let foodCardSection = "FoodCardCell"
//private let headerCell = "SortHeader"
//private let footerCell = "AllRestaurantsSection"
//
//// This controller contains two view contrller, CategoryViewController and mapViewController.
//class MainPageController: UIViewController, MBProgressHUDProtocol {
//  //MARK: - Properties
//  private let navBarView = MainPageNavigationBar()
//
//  internal let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//  private let mapVC = MapViewController()
//  private let categoryVC : MainListViewController = {
//    let cv = MainListViewController(collectionViewLayout: UICollectionViewFlowLayout())
//    return cv
//  }()
//
//  private var errorView: ErrorView?
//
//  private var dataSource: Array<MainListSectionViewObject> = []
//  private let disposeBag = DisposeBag()
//  //MARK: - Lifecycle
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    configureMapView()
//    configureNavBar()
//    configureCategoryView()
//  }
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    navBarSetUp()
//  }
//
//
//}
////MARK: - MainPageHeaderDelegate
//extension MainPageController : MainPageHeaderDelegate {
//  func handleHeaderGotTapped() {
//    mapVC.view.isHidden.toggle()
//    categoryVC.view.isHidden.toggle()
//    mapVC.checkBeforeRestaurantLoaded(completion: nil)
//  }
//}
////MARK: - Autolayout {
//extension MainPageController {
//  func navBarSetUp(){
//    navigationController?.navigationBar.barStyle = .default
//    navigationController?.navigationBar.isHidden = true
//    navigationController?.navigationBar.isTranslucent = true
//    tabBarController?.tabBar.isHidden = false
//    tabBarController?.tabBar.isTranslucent = true
//  }
//  func configureNavBar(){
//    navBarView.delegate = self
//    view.addSubview(navBarView)
//    let heightMultiplier = UIScreen.main.bounds.height / CGFloat(896)
//    let height = heightMultiplier * 98
//    navBarView.anchor(top: view.topAnchor, left: view.leftAnchor,
//                      right: view.rightAnchor, height: height)
//
//  }
//  func configureCategoryView(){
//    guard let categoryView = categoryVC.view else { return }
//    self.addChild(categoryVC)
//    view.insertSubview(categoryView, at: 1)
//    categoryView.isHidden = false
//    categoryView.anchor(top: navBarView.bottomAnchor,left: view.leftAnchor,
//                        right: view.rightAnchor, bottom: view.bottomAnchor)
//  }
//
//  func configureMapView(){
//    guard let map = mapVC.view else { return }
//    self.addChild(mapVC)
//    view.insertSubview(map, at: 2)
//    map.isHidden = true
//  }
//}
