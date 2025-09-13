//
//  WheelViewControllerRepresentable.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/4/2.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import SwiftUI

struct WheelViewControllerRepresentable: UIViewControllerRepresentable {
  let pocket: Pocket?

  typealias UIViewControllerType = WheelViewController

  func makeUIViewController(context: Context) -> WheelViewController {
    let wheelItems = WheelItem.dummyItems
    let config = WheelConfiguration(buttonEnable: !pocket.isNil, diameter: 330)
    return WheelViewController(wheelItems: wheelItems, configuration: config)
  }

  func updateUIViewController(
		_ uiViewController: WheelViewController,
		context: Context
	) {
		if let places = pocket?.places {
			let data = WheelItem.createWheel(items: places.map { ($0.id, $0.name) })
			uiViewController.refreshView(with: data)
		}
  }
}

#Preview {
	WheelViewControllerRepresentable(pocket: nil)
}

extension WheelViewController: WheelDelegate, WheelDataSource {
	var items: [WheelItem] {
		wheelItems.isEmpty ? WheelItem.dummyItems : wheelItems
	}

  func wheelDidChangeValue(_: Int) {}

  func onClickItem(id: String) {
  }

  func numberOfSections() -> Int {
		items.count
  }

  func itemsForSections() -> [WheelItem] {
		items
  }
}
