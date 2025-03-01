//
//  TextFieldClearButton.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/23.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct TextFieldClearButton: ViewModifier {
  @Binding var text: String
  var onClear: (() -> Void)?

  func body(content: Content) -> some View {
    content.overlay {
      if !text.isEmpty {
        HStack {
          Spacer()
          Button {
            text = ""
            onClear?()
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
  func showClearButton(text: Binding<String>, onClear: (() -> Void)? = nil) -> some View {
    modifier(TextFieldClearButton(text: text, onClear: onClear))
  }
}
