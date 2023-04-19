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
import SwiftUI

class MainTabBarController: TabBarController {
	//MARK: - Properties
	private let spinTabItemView = SpinTabItemView(frame: .zero)

//	private var set = Set<AnyCancellable>()
	//MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		overrideUserInterfaceStyle = .light
		configureTabBar()
	}
}

//MARK: -  HomeController setup
extension MainTabBarController {
	func configureTabBar(){
		view.backgroundColor = .backgroundColor
		tabBar.backgroundColor = .white
		tabBar.backgroundImage = UIImage(resource: R.image.bar, with: nil)?.withRenderingMode(.alwaysOriginal)
		tabBar.tintColor = .black
		tabBar.layer.cornerRadius = 36
		tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		tabBar.layer.masksToBounds = true
		tabBar.isTranslucent = true
	}
	
	override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
		super.setViewControllers(viewControllers, animated: animated)
		let spinTabItem = tabBar.subviews[1]
		spinTabItem.addSubview(spinTabItemView)
		spinTabItemView.center(inView: spinTabItem, yConstant: 12)
	}
}
 // MARK: - Animation
extension MainTabBarController {
	override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		guard let index = tabBar.items?.firstIndex(of: item) else { return }
		guard let view = tabBar.subviews[index+1].subviews.last else { return }
		let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
		bounceAnimation.values = [1.0, 1.1, 0.95, 1.02, 1.0]
		bounceAnimation.duration = TimeInterval(0.2)
		bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
		view.layer.add(bounceAnimation, forKey: nil)
	}
}
