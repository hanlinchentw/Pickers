//
//  TabView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/6/28.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import SwiftUI

struct RootView: View {
	@State var selectedIndex: Int = 0
	
	init() {
		UITabBar.appearance().isHidden = true
	}
	
	var body: some View {
		ZStack(alignment: .bottom) {
			TabView(selection: $selectedIndex) {
				ExplorerView()
					.tag(0)
					.ignoresSafeArea()
				WheelView()
					.tag(1)
				PocketView()
					.tag(2)
			}

			TabBarView(selectedTab: $selectedIndex)
				.frame(height: 80)
				.background(.white)
				.clipped()
				.cornerRadius(36)
		}
	}
}

struct TabView_Previews: PreviewProvider {
	static var previews: some View {
		RootView()
	}
}
