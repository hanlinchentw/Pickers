//
//  MainTabContainerView.swift
//  Picker
//
//  Created by 陳翰霖 on 2025/8/15.
//

import SwiftUI

struct MainTabContainerView: View {
	@State private var selectedTab: MainTabType = .home
	private var store: PlacesSelectionStore { .shared }

	var selectedPlaceCount: Int { store.selectedPlaces.count }

	var body: some View {
		VStack {
			Spacer()
			Group {
				switch selectedTab {
				case .home:
					ExploreView()
				case .picker:
					PocketWheelContainerView()
				case .favorite:
					Text("Preparing")
				}
			}
			TabBar(selectedTab: $selectedTab, tabs: MainTabType.allCases, selectedPlaceCount: selectedPlaceCount)
		}
		.ignoresSafeArea(.keyboard, edges: .bottom)
	}
}
