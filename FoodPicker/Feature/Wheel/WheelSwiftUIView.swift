//
//  WheelView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/6/28.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import SwiftUI
import WheelUI

struct WheelSwiftUIView: UIViewControllerRepresentable {
	typealias UIViewControllerType = WheelViewController

	@ObservedObject var selectionStore: PlacesSelectionStore

	func makeUIViewController(context: Context) -> WheelViewController {
		let presenter = WheelPresenter(selectionStore: selectionStore)
		let viewController = WheelViewController(presenter: presenter)
		presenter.wheelView = viewController
		return viewController
	}
	
	func updateUIViewController(_ uiViewController: WheelViewController, context: Context) {
		uiViewController.refreshView()
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
