//
//  HomeController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import CoreData

class MainTabBarController : UITabBarController {
  //MARK: - Properties
  var displayTab: Array<MainTabBarConstants.TabItemType> = [.main, .spin, .favorite]
  private let spinTabItemView = SpinTabItemView(frame: .zero)

  private let appDelegate = UIApplication.shared.delegate as! AppDelegate
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    overrideUserInterfaceStyle = .light
    configureTabBar()
  }
}

//MARK: - SelectRestaurant Data flow
extension MainTabBarController {
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
    tabBar.isTranslucent = true

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
  static func createTabItem(type: MainTabBarConstants.TabItemType) -> UIViewController {
    let vc = type.viewController
    vc.tabBarItem.image = UIImage(named: type.defaultTabItemImage)?.withRenderingMode(.alwaysOriginal)
    vc.tabBarItem.selectedImage = UIImage(named: type.selectedTabItemImage)?.withRenderingMode(.alwaysOriginal)
    vc.tabBarItem.imageInsets = UIEdgeInsets(top: 16, left: 0, bottom: -16, right: 0)
    return vc
  }
}