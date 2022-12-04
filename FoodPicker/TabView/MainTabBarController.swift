//
//  HomeController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import CoreData
import Combine


class MainTabBarController: UITabBarController, TabController {
	static let SpinTabImage = "spinActive"
	static let tabImage = "bar"
	typealias TabType = MainTab
	//MARK: - Properties
	private let spinTabItemView = SpinTabItemView(frame: .zero)
	
	private var set = Set<AnyCancellable>()
	//MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		overrideUserInterfaceStyle = .light
		try? SelectedRestaurant.deleteAll(in: CoreDataManager.sharedInstance.managedObjectContext)
		CoreDataManager.sharedInstance.saveContext()
		configureTabBar()
		observeContextObjectsChange()
	}
}

extension MainTabBarController: RestaurantContextDidChangeNotify {
	var contextObjectDidChange: ((Notification) -> Void)? {
		{ notification in
			if let selectedRestaurants = try? SelectedRestaurant.allIn(CoreDataManager.sharedInstance.managedObjectContext) as? Array<SelectedRestaurant> {
				self.spinTabItemView.update(selectedRestaurants.count)
			}
		}
	}
}

//MARK: -  HomeController setup
extension MainTabBarController{
	func configureTabBar(){
		view.backgroundColor = .backgroundColor
		viewControllers = self.displayViewControllers
		self.selectedIndex = 0
		tabBar.backgroundColor = .white
		tabBar.backgroundImage = UIImage(named: Self.tabImage)?.withRenderingMode(.alwaysOriginal)
		tabBar.tintColor = .black
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
		bounceAnimation.values = [1.0, 1.1, 0.95, 1.02, 1.0]
		bounceAnimation.duration = TimeInterval(0.2)
		bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
		view.layer.add(bounceAnimation, forKey: nil)
		
		if index == 0 {
			NotificationCenter.default.post(name: .init(Constants.firstTabGotTapped), object: nil)
		}
	}
}
