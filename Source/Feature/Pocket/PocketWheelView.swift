//
//  PocketWheelView.swift
//  Picker
//
//  Created by 陳翰霖 on 2025/6/19.
//

import SwiftUI

struct PocketWheelView<WheelView: View>: View {
	// MARK: - States
	let isPocketEmpty: Bool

	// MARK: - Actions
	let currentPocketName: String?
	let onAppear: () -> Void
	let onExplore: () -> Void
	let onPressSettings: () -> Void
	let onPressPocketMenu: () -> Void
	let onPressEditList: () -> Void
	let onPressEmptyAction: () -> Void

	// MARK: - Injected View
	let wheelView: () -> WheelView

	var body: some View {
		VStack {
			topHorizontalView.padding(.horizontal)
			wheelView()
			if isPocketEmpty {
				emptyView
			} else {
				editListBtn
			}
		}
		.onAppear { onAppear() }
	}
}

// MARK: - Sub views
private extension PocketWheelView {
	@ViewBuilder var topHorizontalView: some View {
		ZStack {
			HStack {
				Button(action: onPressSettings) {
					Image(R.image.settings.name)
						.size(28)
						.foregroundStyle(Color.primary)
				}
				Spacer()
			}
			pocketSwitchEntryView
		}
	}

	@ViewBuilder var pocketSwitchEntryView: some View {
		ZStack {
				let title = currentPocketName ?? "Create a New Pocket"
				Text(title).en16Bold()
				HStack {
						Spacer()
						Image(systemName: "chevron.down")
								.size(14)
								.padding(.trailing)
				}
		}
		.foregroundStyle(Color.primary)
		.frame(width: UIScreen.screenWidth / 2, height: 48)
		.overlay {
			RoundedCorner(radius: 24).stroke(.black)
		}
		.onTapGesture {
			onPressPocketMenu()
		}
	}

	var editListBtn: some View {
		HStack {
			Spacer()
			Button {
				onPressEditList()
			} label: {
				Image(R.image.list)
					.size(16)
					.foregroundStyle(Color.primary)
			}
			.padding()
			.overlay {
				Circle().stroke(Color.primary)
			}
		}
		.padding()
	}
}

// MARK: - Empty View
private extension PocketWheelView {
	@ViewBuilder var emptyView: some View {
		VStack(spacing: 32) {
			Spacer()

			Text("You haven't added anything yet!")
				.en24Bold()
				.padding(.horizontal, 32)
				.multilineTextAlignment(.center)

			VStack(spacing: 20) {
				Button {
					onPressEmptyAction()
				} label: {
					Text("Create New Pocket!")
						.en16Bold()
						.foregroundStyle(.white)
				}
				.padding()
				.padding(.horizontal)
				.background(
					RoundedRectangle(cornerRadius: 20).fill(Color.butterScotch).opacity(0.85)
				)
				.clipShape(Capsule())
			}

			Spacer()
		}
	}
}

#Preview {
	PocketWheelView(
		isPocketEmpty: false,
		currentPocketName: "My Pocket",
		onAppear: {},
		onExplore: {},
		onPressSettings: {},
		onPressPocketMenu: {},
		onPressEditList: {},
		onPressEmptyAction: {},
		wheelView: {
			WheelViewControllerRepresentable(pocket: nil)
		}
	)
}
