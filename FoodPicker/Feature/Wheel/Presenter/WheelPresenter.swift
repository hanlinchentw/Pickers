//
//  WheelPresenter.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/29.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation
import WheelUI

protocol WheelPresenting: AnyObject {
}

protocol WheelView: AnyObject {
	func refreshView()
}

final class WheelPresenter: NSObject, WheelPresenting {
	weak var wheelView: WheelView?
	var wheelItems: Array<WheelItem> = WheelItem.dummyItems
	var selectionStore: PlacesSelectionStore

	init(selectionStore: PlacesSelectionStore) {
		self.selectionStore = selectionStore
	}
	
	func refreshWheel() {
		if selectionStore.selectedPlaces.isEmpty {
			wheelItems = WheelItem.dummyItems
			return
		}
		wheelItems = selectionStore.selectedPlaces.enumerated().map {
			WheelItem(id: $1.id, title: $1.name, titleColor: .customblack, itemColor: $0 % 2 == 0 ? .white : .pale)
		}
	}
}

extension WheelPresenter: SpinWheelDelegate, SpinWheelDataSource {
	func wheelDidChangeValue(_ newValue: Int) {
		
	}
	
	func numberOfSections() -> Int {
		wheelItems.count
	}
	
	func itemsForSections() -> [WheelUI.WheelItem] {
		wheelItems
	}
}
