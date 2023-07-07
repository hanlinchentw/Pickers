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

	var body: some View {
		HStack {
			Spacer().frame(width: 36)
			TabItemView(tab: TabItems.explore, isActive: selectedTab == TabItems.explore.rawValue) {
				selectedTab = TabItems.explore.rawValue
			}
			Spacer()
			TabItemView(tab: TabItems.wheel, isActive: selectedTab == TabItems.wheel.rawValue) {
				selectedTab = TabItems.wheel.rawValue
			}
			Spacer()
			TabItemView(tab: TabItems.pocket, isActive: selectedTab == TabItems.pocket.rawValue) {
				selectedTab = TabItems.pocket.rawValue
			}
			Spacer().frame(width: 36)
		}
	}
}

struct TabBarView_Previews: PreviewProvider {
	static var previews: some View {
		TabBarView(selectedTab: .constant(0))
	}
}
