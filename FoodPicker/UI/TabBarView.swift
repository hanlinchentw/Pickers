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
				Image(uiImage: TabItems.explore.item.image ?? UIImage())
					.renderingMode(.original)
					.padding(.horizontal)
					.padding(.vertical, 4)
			} selectedImage: {
				Image(uiImage: TabItems.explore.item.selectedImage ?? UIImage())
					.renderingMode(.original)
					.padding(.horizontal)
					.padding(.vertical, 4)
			}

			Spacer()

			TabItemView(isActive: selectedTab == TabItems.wheel.rawValue) {
				selectedTab = TabItems.wheel.rawValue
			} image: {
				spinTabItem
			} selectedImage: {
				spinTabItem
			}

			Spacer()

			TabItemView(isActive: selectedTab == TabItems.pocket.rawValue) {
				selectedTab = TabItems.pocket.rawValue
			} image: {
				Image(uiImage: TabItems.pocket.item.image ?? UIImage())
					.renderingMode(.original)
					.padding(.horizontal)
					.padding(.vertical, 4)
			} selectedImage: {
				Image(uiImage: TabItems.pocket.item.selectedImage ?? UIImage())
					.renderingMode(.original)
					.padding(.horizontal)
					.padding(.vertical, 4)
			}

			Spacer().frame(width: 36)
		}
	}

	var spinTabItem: some View {
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
}

struct TabBarView_Previews: PreviewProvider {
	static var previews: some View {
		TabBarView(selectedTab: .constant(0), count: 1)
	}
}
