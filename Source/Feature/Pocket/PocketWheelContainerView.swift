//
//  PocketWheelView.swift
//  Picker
//
//  Created by 陳翰霖 on 2024/10/6.
//

import SwiftData
import SwiftUI

struct PocketWheelContainerView: View {
	@Environment(\.modelContext)
	private var modelContext
	@State private var isSwitchPocketSheetPresented = false
	@State private var isSettingsSheetPresented = false
	@State private var toBeEditedPocket: Pocket?
	@Binding var currentPocket: Pocket?

	var onExploring: () -> Void

	var pockets: [Pocket] = []

	var isPocketEmpty: Bool { pockets.isEmpty }

	var body: some View {
		PocketWheelView(
			isPocketEmpty: isPocketEmpty,
			currentPocketName: currentPocket?.name,
			onAppear: onAppear,
			onExplore: goExplore,
			onPressSettings: goSettings,
			onPressPocketMenu: onPressPocketMenu,
			onPressEditList: onPressEditList,
			onPressEmptyAction: onPressEmptyAction,
			wheelView: { wheelView }
		)
		.sheet(isPresented: $isSwitchPocketSheetPresented) {
			switchPocketSheetView
				.padding(.top)
				.presentationDragIndicator(.visible)
		}
		.sheet(item: $toBeEditedPocket) { pocket in
			EditPocketContainerView(
				pocket: pocket,
				onExplore: goExplore
			) { newPocket in
				endEditingPocket(newPocket)
			}
		}
		.fullScreenCover(isPresented: $isSettingsSheetPresented) {
			Text("Setteings View incoming!")
		}
	}

	@ViewBuilder var wheelView: some View {
		WheelViewControllerRepresentable(pocket: currentPocket)
	}

	@ViewBuilder var switchPocketSheetView: some View {
		SwitchPocketView(pockets: pockets) {
			createNewPocket()
			hideSwitchPocketSheet()
		} onSelectPocket: { pocket in
			selectPocket(pocket)
			hideSwitchPocketSheet()
		} onRemovePocket: { pocket in
			deletePocket(pocket)
		} onClickEditBtn: { pocket in
			hideSwitchPocketSheet()
			toBeEditedPocket = pocket
		}
	}
}

// MARK: - Actions
extension PocketWheelContainerView {
	func onAppear() {
		currentPocket = pockets.first
	}

	func onPressPocketMenu() {
		isSwitchPocketSheetPresented = true
	}

	func onPressEditList() {
		toBeEditedPocket = currentPocket
	}

	func onPressEmptyAction() {
		createNewPocket()
	}

	func goExplore() {
		onExploring()
		toBeEditedPocket = nil
	}

	func goSettings() {
		isSettingsSheetPresented = true
	}

	func createNewPocket() {
		toBeEditedPocket = Pocket(id: UUID().uuidString, name: "")
	}

	func endEditingPocket(_ pocket: Pocket) {
		updateOrInsertPocket(pocket)
		selectPocket(pocket)
		toBeEditedPocket = nil
	}

	func hideSwitchPocketSheet() {
		isSwitchPocketSheetPresented = false
	}

	func selectPocket(_ pocket: Pocket) {
		currentPocket = pocket
	}

	func updateOrInsertPocket(_ upcomingPocket: Pocket) {
	}

	func deletePocket(_ pocket: Pocket) {
	}
}

#Preview {
	PocketWheelContainerView(currentPocket: .constant(nil)) {
		print("Hello")
	}
}
