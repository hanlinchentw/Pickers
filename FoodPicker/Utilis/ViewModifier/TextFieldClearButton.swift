//
//  TextFieldClearButton.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/23.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct TextFieldClearButton: ViewModifier {
	var onClear: () -> Void
	
	func body(content: Content) -> some View {
		content.overlay {
			if !text.isEmpty {
				 HStack {
					 Spacer()
					 Button {
						 onClear()
					 } label: {
						 Image(systemName: "multiply.circle.fill")
					 }
					 .foregroundColor(.gray.opacity(0.7))
					 .padding(.trailing, 12)
				 }
			 }
		 }
	}
}

extension View {
	func showClearButton(onClear: @escaping () -> Void) -> some View {
		self.modifier(TextFieldClearButton(onClear: onClear))
	}
}

