//
//  TabBar.swift
//  Picker
//
//  Created by 陳翰霖 on 2025/8/18.
//

import SwiftUI

struct TabBar: View {
	@Binding var selectedTab: MainTabType
	let tabs: [MainTabType]

	let selectedPlaceCount: Int

	var body: some View {
		HStack {
			ForEach(tabs, content: tabItem(for:))
		}
		.padding(.vertical, 10)
		.background(
			RoundedRectangle(cornerRadius: 20)
				.fill(Color(.systemBackground))
				.clipShape(Capsule())
				.shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
		)
		.padding(.horizontal, 16)
	}
}

private extension TabBar {
	@ViewBuilder
	func tabItem(for tab: MainTabType) -> some View {
		Button {
			withAnimation(.spring()) {
				selectedTab = tab
			}
		} label: {
			VStack {
				let isSelected = selectedTab == tab
				let image = isSelected ? tab.selectedImage : tab.image

				if tab == .picker, selectedPlaceCount != 0 {
					Image(R.image.spinActive)
						.overlay { overlayedPickedCount }
				} else {
					Image(image)
				}
			}
			.frame(maxWidth: .infinity)
		}
	}

	var overlayedPickedCount: some View {
		ZStack {
			Circle()
				.fill(Color.butterScotch)
			Text("\(selectedPlaceCount)")
				.en14Bold()
				.foregroundStyle(.white)
		}
	}
}
