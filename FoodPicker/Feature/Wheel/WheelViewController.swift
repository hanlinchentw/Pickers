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
	var selectionStore: PlacesSelectionStore

	lazy var wheel: Wheel = {
		let wheel = Wheel(radius: 330/2)
		wheel.animateLanding = false
		wheel.delegate = self
		wheel.dataSource = self
		wheel.setDimension(width: 330, height: 330)
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

	init(selectionStore: PlacesSelectionStore) {
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

		if selectionStore.selectedPlaces.isEmpty {
			wheelItems = WheelItem.dummyItems
			return
		}
		
		wheelItems = selectionStore.selectedPlaces.enumerated().map {
			WheelItem(id: $1.id, title: $1.name, titleColor: .customblack, itemColor: $0 % 2 == 0 ? .white : .pale)
		}
	}

	@objc func didTapActionButton() {
		actionButton.isUserInteractionEnabled = false
		actionButton.performBounceAnimataion(scale: 1.1, duration: 0.1)
		wheel.start { self.actionButton.isUserInteractionEnabled = true }
	}
}

extension WheelViewController {
	func setupWheelUI () {
		view.addSubview(wheel)
		wheel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 64)
		wheel.centerX(inView: view)
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
