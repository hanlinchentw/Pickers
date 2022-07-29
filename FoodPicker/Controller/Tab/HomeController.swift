//
//  HomeController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import CoreData

enum SelectRestaurantResult: Error {
  case success
  case upToLimit
  case error
}
class HomeController : UITabBarController, MBProgressHUDProtocol {
  //MARK: - Properties
  var selectedRestaurantCount = 0
  private let numOfSelectedLabel : UILabel = {
    let label = UILabel()
    label.font = UIFont.arialBoldMT
    label.textColor = .white
    return label
  }()
  private lazy var actionIconView : UIImageView = {
    let iv = UIImageView()
    iv.backgroundColor = .butterscotch
    iv.image = UIImage(named: "spinActive")
    iv.contentMode = .scaleAspectFit
    iv.setDimension(width: 54, height: 54)
    iv.layer.cornerRadius = 54 / 2

    iv.addSubview(numOfSelectedLabel)
    numOfSelectedLabel.center(inView: iv)
    return iv
  }()

  private let appDelegate = UIApplication.shared.delegate as! AppDelegate
  private lazy var context = appDelegate.persistentContainer.viewContext
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    authenticateUserAndConfigureUI()
    overrideUserInterfaceStyle = .light
  }
  //MARK: - API
  func authenticateUserAndConfigureUI(){
    configureTabBar()
    configureTabBarController()
    observeEntityChange()
  }
}

//MARK: - SelectRestaurant Data flow
extension HomeController {
  func observeEntityChange(){
    NotificationCenter.default.addObserver(self, selector: #selector(contextDidChange), name: NSManagedObjectContext.didSaveObjectsNotification, object: context)
  }
  @objc func contextDidChange(_ notification: NSNotification){
    guard let userInfo = notification.userInfo else { return }

    if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
       inserts.count > 0 {
      let object = inserts.first
      if let _ = object as? SelectedRestaurant{
        self.selectedRestaurantCount += 1
        self.configureActionIcon()
      }
    }
    if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> ,
       deletes.count > 0 {
      let object = deletes.first
      if let _ = object as? SelectedRestaurant{
        self.selectedRestaurantCount -= 1
        self.configureActionIcon()
      }
    }
  }
}
//MARK: -  Search Restaurants from category cards
extension HomeController {
  func searchRestaurantsFromCategoryCard(textOnCard text: String) {
    self.showLoadingAnimation()
    UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve) {
      self.selectedIndex = 1
    } completion: { _ in
      guard let nav = self.viewControllers?[1] as? UINavigationController else { return }
      guard let searchVC = nav.viewControllers[0] as? SearchController else { return }
      Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
        if searchVC.isViewLoaded {
          searchVC.searchRestaurants(withKeyword: text)
          timer.invalidate()
        }
      }
    }
  }
}
//MARK: - ProfileControllerDelegate
extension HomeController {
  func logOutButtonTapped() {
    authenticateUserAndConfigureUI()
  }
}
//MARK: -  HomeController setup
extension HomeController{
  func configureActionIcon(){
    if selectedRestaurantCount == 0 {
      numOfSelectedLabel.text = nil
      actionIconView.image = UIImage(named: "spinActive")
    }else {
      actionIconView.image = nil
      numOfSelectedLabel.changeLabelWithBounceAnimation(changeTo: "\(selectedRestaurantCount)")
    }
  }
  func configureTabBar(){
    view.backgroundColor = .backgroundColor
    tabBar.addSubview(actionIconView)
    print(UIScreen.main.bounds.height)
    let offset = UIScreen.main.bounds.height < 700 ? 0 : -10 * view.heightMultiplier
    actionIconView.center(inView: tabBar, yConstant: offset)

    tabBar.backgroundColor = .white
    tabBar.backgroundImage = UIImage(named: "bar")?.withRenderingMode(.alwaysOriginal)
    tabBar.layer.cornerRadius = 36
    tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    tabBar.layer.masksToBounds = true
    self.selectedIndex = 0
  }

  func configureTabBarController(){
    // Create main page view controller
    let main = MainPageController()
    let nav1 = templateNavigationController(image: UIImage(named: "homeUnselectedS"),
                                            rootViewController: main)
    nav1.tabBarItem.selectedImage = UIImage(named: "homeSelectedS")?.withRenderingMode(.alwaysOriginal)
    // Create searcg page view controller
    let search = SearchController(collectionViewLayout: UICollectionViewFlowLayout())
    let nav2 = templateNavigationController(image: UIImage(named: "searchUnselectedS"),
                                            rootViewController: search)
    nav2.tabBarItem.selectedImage = UIImage(named: "searchSelectedS")?.withRenderingMode(.alwaysOriginal)
    // Create Spin page view controller
    let action = ActionViewController()
    let nav3 = templateNavigationController(image: UIImage(named: ""),
                                            rootViewController: action)
    action.observeEntityChange()
    // Create favorite View controller
    let favorite = FavoriteController()
    let nav4 = templateNavigationController(image: UIImage(named: "favoriteUnselectedS"),
                                            rootViewController: favorite)
    favorite.fetchLikedRestauants()
    nav4.tabBarItem.selectedImage = UIImage(named: "icnTabHeartSelected")?.withRenderingMode(.alwaysOriginal)

    viewControllers = [nav1, nav2, nav3, nav4]
  }
  func templateNavigationController(image: UIImage?, rootViewController:UIViewController) -> UINavigationController{
    let nav = UINavigationController(rootViewController: rootViewController)
    nav.tabBarItem.image = image?.withRenderingMode(.alwaysOriginal)
    let offset = view.heightMultiplier * 12
    nav.tabBarItem.imageInsets = UIEdgeInsets(top: offset, left: 0, bottom: -offset, right: 0)
    return nav
  }
}
