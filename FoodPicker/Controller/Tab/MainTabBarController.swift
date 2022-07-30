//
//  HomeController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import CoreData

enum TabItemType {
  case main
  case search
  case favorite
  case spin

  var viewController: UIViewController.Type {
    switch self {
    case .main: return MainPageController.self
    case .search: return SearchTableViewController.self
    case .favorite: return FavoriteController.self
    case .spin: return ActionViewController.self
    }
  }

  var defaultTabItemImage: String {
    switch self {
    case .main: return "homeUnselectedS"
    case .search: return "searchUnselectedS"
    case .favorite: return "favoriteUnselectedS"
    case .spin: return ""
    }
  }

  var selectedTabItemImage: String {
    switch self {
    case .main: return "homeSelectedS"
    case .search: return "searchSelectedS"
    case .favorite: return "icnHeartXs"
    case .spin: return ""
    }
  }
}

class MainTabBarController : UITabBarController, MBProgressHUDProtocol {
  //MARK: - Properties
  var displayTab: Array<TabItemType> = [.main, .search, .favorite, .spin]

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
    overrideUserInterfaceStyle = .light
    configureTabBar()
    observeEntityChange()
  }
}

//MARK: - SelectRestaurant Data flow
extension MainTabBarController {
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
extension MainTabBarController {
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

//MARK: -  HomeController setup
extension MainTabBarController{
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
    viewControllers = displayTab.map { TabItemFactory.createTabItem(type: $0) }
    self.selectedIndex = 0
    tabBar.backgroundColor = .white
    tabBar.backgroundImage = UIImage(named: "bar")?.withRenderingMode(.alwaysOriginal)
    tabBar.layer.cornerRadius = 36
    tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    tabBar.layer.masksToBounds = true

    let spinTabItem = tabBar.subviews.last
    spinTabItem!.addSubview(actionIconView)
    actionIconView.center(inView: spinTabItem!, yConstant: 16)
  }
}

extension MainTabBarController: UITabBarControllerDelegate {
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    guard let index = tabBar.items?.firstIndex(of: item) else { return }
    guard let view = tabBar.subviews[index+1].subviews.last else { return }
    let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
    bounceAnimation.values = [1.0, 1.3, 0.9, 1.02, 1.0]
    bounceAnimation.duration = TimeInterval(0.3)
    bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
    view.layer.add(bounceAnimation, forKey: nil)
  }
}

//MARK: - TabItem Factory
struct TabItemFactory {
  static func createTabItem(type: TabItemType) -> UINavigationController {
    let nav = UINavigationController(rootViewController: type.viewController.init(nibName: nil, bundle: nil))
    nav.tabBarItem.image = UIImage(named: type.defaultTabItemImage)?.withRenderingMode(.alwaysOriginal)
    nav.tabBarItem.selectedImage = UIImage(named: type.selectedTabItemImage)?.withRenderingMode(.alwaysOriginal)
    nav.tabBarItem.imageInsets = UIEdgeInsets(top: 16, left: 0, bottom: -16, right: 0)
    return nav
  }
}


//action.observeEntityChange()
//favorite.fetchLikedRestauants()
