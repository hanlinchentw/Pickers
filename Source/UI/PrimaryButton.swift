//
//  PrimaryButton.swift
//  Picker
//
//  Created by 陳翰霖 on 2025/3/19.
//

import SwiftUI

struct PrimaryButton: View {
	let title: String
	var image: Image?
	var width: CGFloat?
	let action: () -> Void

	var bold = true
	var disabled = false

	var body: some View {
		Button {
			action()
		} label: {
			Text(title)
				.if(bold) {
					$0?.en16Bold()
				} elsewhat: {
					$0?.en16Medium()
				}
				.ifLet(image) { image, label in
					HStack(spacing: 8) {
						image
							.if(bold) {
								$0?.bold()
							}
						label
					}
				}
				.padding()
				.frame(maxWidth: width)
				.background(disabled ? Color.gray4 : Color.butterScotch)
				.foregroundColor(.white)
				.cornerRadius(12)
				.if(!disabled) {
					$0.shadow(radius: 5)
				}
		}
		.disabled(disabled)
	}
}

#Preview {
	PrimaryButton(
		title: "Title",
		image: Image(systemName: "xmark"),
		width: .infinity
	) {
		print("123")
	}
}
