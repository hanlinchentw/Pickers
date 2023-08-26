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
		let wheel = Wheel()
		wheel.animateLanding = false
		return wheel
	}()
	
	var wheelItems: Array<WheelItem> = [
		WheelItem(id: UUID().uuidString, title: "Picker! 1", titleColor: .customblack, itemColor: .white),
		WheelItem(id: UUID().uuidString, title: "Picker! 2", titleColor: .customblack, itemColor: .pale),
		WheelItem(id: UUID().uuidString, title: "Picker! 3", titleColor: .customblack, itemColor: .white),
		WheelItem(id: UUID().uuidString, title: "Picker! 4", titleColor: .customblack, itemColor: .pale),
	]

	init(selectionStore: RestaurantSelectionStore) {
		self.selectionStore = selectionStore
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		wheel.delegate = self
		wheel.dataSource = self
		view.addSubview(wheel)
		wheel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 64)
		wheel.setDimension(width: 330, height: 330)
		wheel.centerX(inView: view)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		wheel.reloadData()
	}

	func refreshWheel() {
		wheelItems = selectionStore.selectedRestaurants.enumerated().map {
			WheelItem(id: $1.id, title: $1.name, titleColor: .customblack, itemColor: $0 % 2 == 0 ? .white : .pale)
		}
		wheel.reloadData()
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
