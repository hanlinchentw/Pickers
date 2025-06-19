//
//  SecondaryButton.swift
//  Picker
//
//  Created by 陳翰霖 on 2025/3/20.
//

import SwiftUI

struct SecondaryButton: View {
	let title: String
	var image: Image?
	var width: CGFloat?
	var role: ButtonRole = .cancel
	let action: () -> Void

	var disabled = false

	var body: some View {
		Button(role: role) {
			action()
		} label: {
			Text(title)
				.if(!disabled) {
					$0.en16Medium()
				}
				.ifLet(image) { image, label in
					HStack(spacing: 8) {
						image
						label
					}
				}
				.padding()
				.frame(maxWidth: width)
				.overlay {
					RoundedRectangle(cornerRadius: 12)
						.stroke(Color.gray3)
				}
				.foregroundColor(role == .destructive ? .red : .black)
		}
		.disabled(disabled)
	}
}

#Preview {
	SecondaryButton(title: "Title", image: Image(systemName: "xmark"), width: .infinity) {
		print("123")
	}
}

