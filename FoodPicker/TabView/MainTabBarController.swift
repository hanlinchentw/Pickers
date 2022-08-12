//
//  HomeController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import CoreData

class MainTabBarController : UITabBarController, MBProgressHUDProtocol {
  //MARK: - Properties
  var displayTab: Array<MainTabBarConstants.TabItemType> = [.main, .spin, .favorite]
  private let spinTabItemView = SpinTabItemView(frame: .zero)

  private let appDelegate = UIApplication.shared.delegate as! AppDelegate
  private lazy var context = appDelegate.persistentContainer.viewContext
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    overrideUserInterfaceStyle = .light
    configureTabBar()
    NotificationCenter.default.addObserver(self, selector: #selector(contextDidChange), name: NSManagedObjectContext.didSaveObjectsNotification, object: context)
  }
}

//MARK: - SelectRestaurant Data flow
extension MainTabBarController {
  @objc func contextDidChange(_ notification: NSNotification){
    guard let userInfo = notification.userInfo else { return }
    if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
       let _ = inserts.first as? SelectedRestaurant{
      self.spinTabItemView.increase()
    }
    if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
        let _ = deletes.first as? SelectedRestaurant {
      self.spinTabItemView.decrease()
    }
  }
}

//MARK: -  HomeController setup
extension MainTabBarController{
  func configureTabBar(){
    view.backgroundColor = .backgroundColor
    viewControllers = displayTab.map { TabItemFactory.createTabItem(type: $0) }
    self.selectedIndex = 0
    tabBar.backgroundColor = .white
    tabBar.backgroundImage = UIImage(named: MainTabBarConstants.tabImage)?.withRenderingMode(.alwaysOriginal)
    tabBar.layer.cornerRadius = 36
    tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    tabBar.layer.masksToBounds = true

    let spinTabItem = tabBar.subviews[1]
    spinTabItem.addSubview(spinTabItemView)
    spinTabItemView.center(inView: spinTabItem, yConstant: 12)
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
final class TabItemFactory {
  static func createTabItem(type: MainTabBarConstants.TabItemType) -> UINavigationController {
    let nav = UINavigationController(rootViewController: type.viewController)
    nav.tabBarItem.image = UIImage(named: type.defaultTabItemImage)?.withRenderingMode(.alwaysOriginal)
    nav.tabBarItem.selectedImage = UIImage(named: type.selectedTabItemImage)?.withRenderingMode(.alwaysOriginal)
    nav.tabBarItem.imageInsets = UIEdgeInsets(top: 16, left: 0, bottom: -16, right: 0)
    return nav
  }
}
