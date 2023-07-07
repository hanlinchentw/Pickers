//
//  WheelView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/6/28.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import SwiftUI

struct WheelView: UIViewControllerRepresentable {
	typealias UIViewControllerType = WheelViewController
	
	func makeUIViewController(context: Context) -> WheelViewController {
		return WheelViewController()
	}
	
	func updateUIViewController(_ uiViewController: WheelViewController, context: Context) {}
}
