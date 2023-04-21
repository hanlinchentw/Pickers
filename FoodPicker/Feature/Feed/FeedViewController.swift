//
//  FeedViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/21.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit

final class FeedViewController: UIViewController {
	// MARK: - Property
	let listViewController: ListViewController
	let mapViewController: MapViewController
	weak var coordinator: FeedCoordinator?
	// MARK: - Lifecycle
	init(listViewController: ListViewController, mapViewController: MapViewController) {
		self.listViewController = listViewController
		self.mapViewController = mapViewController
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		showMap()
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
}
