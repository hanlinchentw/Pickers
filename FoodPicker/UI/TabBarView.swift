//
//  TabBarView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/6/28.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
	@Binding var selectedTab: Int
	var count: Int

	var body: some View {
		HStack {
			Spacer().frame(width: 36)

			TabItemView(isActive: selectedTab == TabItems.explore.rawValue) {
				selectedTab = TabItems.explore.rawValue
			} image: {
				makeItemImage(TabItems.explore.item.image ?? UIImage())
			} selectedImage: {
				makeItemImage(TabItems.explore.item.selectedImage ?? UIImage())
			}

			Spacer()

			TabItemView(isActive: selectedTab == TabItems.wheel.rawValue) {
				selectedTab = TabItems.wheel.rawValue
			} image: {
				makeSpinTabItem(focused: false)
			} selectedImage: {
				makeSpinTabItem(focused: true)
			}

			Spacer()

			TabItemView(isActive: selectedTab == TabItems.pocket.rawValue) {
				selectedTab = TabItems.pocket.rawValue
			} image: {
				makeItemImage(TabItems.pocket.item.image ?? UIImage())
			} selectedImage: {
				makeItemImage(TabItems.pocket.item.selectedImage ?? UIImage())
			}

			Spacer().frame(width: 36)
		}
	}

	func makeSpinTabItem(focused: Bool) -> some View {
		ZStack {
			Circle()
				.foregroundColor(.butterScotch)
			if count == 0 {
				Image(R.image.logoW)
					.resizable()
					.frame(width: 40, height: 40)
			} else {
				Text("\(count)")
					.foregroundColor(.white)
					.font(.arial16BoldMT)
			}
		}
		.frame(width: 54, height: 54)
	}
	
	func makeItemImage(_ uiImage: UIImage, size: CGFloat = 24) -> some View {
		Image(uiImage: uiImage)
			.renderingMode(.original)
			.resizable()
			.frame(width: size, height: size)
			.padding(.horizontal)
			.padding(.vertical, 4)
	}
}

struct TabBarView_Previews: PreviewProvider {
	static var previews: some View {
		TabBarView(selectedTab: .constant(0), count: 1)
	}
}
