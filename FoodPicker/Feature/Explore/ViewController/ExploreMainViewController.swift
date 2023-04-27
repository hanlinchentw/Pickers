//
//  ExploreMainViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/21.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit

final class ExploreMainViewController: UIViewController {
	// MARK: - Property
	let listViewController: FeedViewController
	let mapViewController: MapViewController
	weak var coordinator: ExploreCoordinator?
	// MARK: - Lifecycle
	init(feedViewController: FeedViewController, mapViewController: MapViewController) {
		self.listViewController = feedViewController
		self.mapViewController = mapViewController
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		showList()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.isHidden = true
		self.tabBarController?.tabBar.isHidden = false
	}
	
	func showMap() {
		addChild(mapViewController)
		view.addSubview(mapViewController.view)
		mapViewController.view.fit(inView: view)
	}
	
	func showList() {
		addChild(listViewController)
		view.addSubview(listViewController.view)
		listViewController.view.fit(inView: view)
	}
}
