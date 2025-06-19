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

	init(pocket: Pocket?) {
		if let pocket {
			_pocket = State(wrappedValue: pocket)
		} else {
			let newPocket = Pocket(id: UUID().uuidString, name: "", places: [])
			_pocket = State(wrappedValue: newPocket)
		}
	}

	var body: some View {
		NavigationStack {
			EditPocketView(pocket: $pocket)
		}
	}
}