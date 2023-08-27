//
//  WheelViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/22.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit
import WheelUI

final class WheelViewController: UIViewController {
	var selectionStore: RestaurantSelectionStore

	lazy var wheel: Wheel = {
		let wheel = Wheel(radius: 330/2)
		wheel.animateLanding = false
		return wheel
	}()
	
	private lazy var actionButton: UIButton = {
		let button = UIButton()
		var configuration = UIButton.Configuration.plain()
		configuration.image = UIImage(named: R.image.btnSpin.name)?.withRenderingMode(.alwaysOriginal)
		button.configuration = configuration
		button.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
		return button
	}()
	
	var wheelItems: Array<WheelItem> = WheelItem.dummyItems

	init(selectionStore: RestaurantSelectionStore) {
		self.selectionStore = selectionStore
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupWheelUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		wheel.reloadData()
	}

	func refreshWheel() {
		defer { wheel.reloadData() }

		if selectionStore.selectedRestaurants.isEmpty {
			wheelItems = WheelItem.dummyItems
			return
		}
		
		wheelItems = selectionStore.selectedRestaurants.enumerated().map {
			WheelItem(id: $1.id, title: $1.name, titleColor: .customblack, itemColor: $0 % 2 == 0 ? .white : .pale)
		}
	}

	@objc func didTapActionButton() {
		actionButton.isUserInteractionEnabled = false

		let zoomAnimation = CGAffineTransform(scaleX: 1.2, y: 1.2)
		UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
			self.actionButton.transform = zoomAnimation
		} completion: { _ in
			UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) {
				self.actionButton.transform = .identity
			}
		}
		wheel.setTarget(section: Int.random(in: 0 ..< self.numberOfSections()))
		wheel.start {
			self.actionButton.isUserInteractionEnabled = true
		}
	}
}

extension WheelViewController {
	func setupWheelUI () {
		view.addSubview(wheel)
		wheel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 64)
		wheel.setDimension(width: 330, height: 330)
		wheel.centerX(inView: view)
		wheel.delegate = self
		wheel.dataSource = self
		
		view.addSubview(actionButton)
		actionButton.center(inView: wheel)
	}
}

extension WheelViewController: SpinWheelDelegate, SpinWheelDataSource {
	func wheelDidChangeValue(_ newValue: Int) {
		
	}
	
	func numberOfSections() -> Int {
		wheelItems.count
	}
	
	func itemsForSections() -> [WheelUI.WheelItem] {
		wheelItems
	}
}

extension WheelItem {
	static var dummyItems: Array<WheelItem> {
		[
			WheelItem(id: UUID().uuidString, title: "Picker! 1", titleColor: .customblack, itemColor: .white),
			WheelItem(id: UUID().uuidString, title: "Picker! 2", titleColor: .customblack, itemColor: .pale),
			WheelItem(id: UUID().uuidString, title: "Picker! 3", titleColor: .customblack, itemColor: .white),
			WheelItem(id: UUID().uuidString, title: "Picker! 4", titleColor: .customblack, itemColor: .pale),
		]
	}
}
