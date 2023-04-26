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

	override func viewDidLoad() {
		super.viewDidLoad()
		wheel.delegate = self
		wheel.dataSource = self
		view.addSubview(wheel)
		wheel.frame = CGRect(x: 0, y: 0, width: 330, height: 330)
		wheel.center = view.center
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		wheel.reloadData()
		wheel.rotate()
		wheel.setTarget(section: 3)
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+5) {
			self.wheel.stop()
		}
	}
}

extension WheelViewController: SpinWheelDelegate, SpinWheelDataSource {
	func wheelDidChangeValue(_ newValue: Int) {
		
	}
	
	func numberOfSections() -> Int {
		return 4
	}
	
	func itemsForSections() -> [WheelUI.WheelItem] {
		return wheelItems
	}
}
