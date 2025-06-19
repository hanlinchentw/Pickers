//
//  EditPocketContainerView.swift
//  
//
//  Created by 陳翰霖 on 2025/3/14.
//


import Kingfisher
import SwiftUI

struct EditPocketContainerView: View {
	@State private var pocket: Pocket

	let onExplore: () -> Void
	let finishEditing: (Pocket) -> Void

	init(pocket: Pocket?, onExplore: @escaping () -> Void, finishEditing: @escaping (Pocket) -> Void) {
		if let pocket {
			_pocket = State(wrappedValue: pocket)
		} else {
			let newPocket = Pocket(id: UUID().uuidString, name: "", places: [])
			_pocket = State(wrappedValue: newPocket)
		}
		self.finishEditing = finishEditing
		self.onExplore = onExplore
	}

	var body: some View {
		NavigationStack {
			EditPocketView()
		}
	}
}
