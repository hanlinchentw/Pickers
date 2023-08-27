//
//  TabView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/6/28.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import SwiftUI
import Combine

struct RootView: View {
	@State var selectedIndex: Int = 1
	@State var tabBarOffset: CGFloat = 0
	@StateObject var selectionStore = RestaurantSelectionStore()
	var heightDidChangePublisher = NotificationCenter.Publisher(center: .default, name: .exploreSlidingSheetHeightDidChange)
	
	init() {
		UITabBar.appearance().isHidden = true
	}
	
	var body: some View {
		ZStack(alignment: .bottom) {
			TabView(selection: $selectedIndex) {
				ExplorerView(selectionStore: selectionStore)
					.tag(0)
					.ignoresSafeArea()
				WheelView(selectionStore: selectionStore)
					.tag(1)
				PocketView()
					.tag(2)
			}

			TabBarView(
				selectedTab: $selectedIndex,
				count: selectionStore.selectedRestaurants.count
			)
				.frame(height: 88)
				.background(.white)
				.clipped()
				.cornerRadius(36)
				.ignoresSafeArea()
				.offset(y: tabBarOffset)
				.animation(.easeInOut, value: tabBarOffset)
		}
		.ignoresSafeArea()
		.onReceive(heightDidChangePublisher) { output in
			guard let ratio = output.userInfo?["ratio"] as? CGFloat else { return }
			tabBarOffset = 88 * (1 - ratio)
		}
	}
}

struct TabView_Previews: PreviewProvider {
	static var previews: some View {
		RootView()
	}
}
