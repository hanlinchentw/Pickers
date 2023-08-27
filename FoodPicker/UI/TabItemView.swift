//
//  TabItemView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/6/28.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import SwiftUI

struct TabItemView<Content1: View, Content2: View>: View {

	var isActive: Bool
	var itemOnPress: () -> Void
	@ViewBuilder var image: () -> Content1
	@ViewBuilder var selectedImage: () -> Content2
	
	var body: some View {
		Button {
			itemOnPress()
		} label: {
			if isActive {
				selectedImage()
			} else {
				image()
			}
		}
	}
}
