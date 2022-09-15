//
//  TwoHorizontalButton.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/15.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct TwoHorizontalButton: View {
  let leftButtonText: String
  let rightButtonText: String

  let buttonSize: CGSize

  var onPressLeftButton: () -> Void
  var onPressRightButton: () -> Void

  var rightButtonDisabled: Bool = false

  var body: some View {
    HStack {
      Spacer()
      Button {
        onPressLeftButton()
      } label: {
        Text(leftButtonText)
          .foregroundColor(.black)
          .en16()
      }
      .frame(width: buttonSize.width, height: buttonSize.height)
      .background(RoundedRectangle(cornerRadius: 16).stroke(.gray))

      Spacer()

      Button {
        onPressRightButton()
      } label: {
        Text(rightButtonText)
          .foregroundColor(.white)
          .en16Bold()
      }
      .frame(width: buttonSize.width, height: buttonSize.height)
      .background(RoundedRectangle(cornerRadius: 16).fill(.black))
      .disabled(rightButtonDisabled)
      Spacer()
    }
    .padding(.bottom, 24)
  }
}

struct TwoHorizontalButton_Previews: PreviewProvider {
  static var previews: some View {
    TwoHorizontalButton(leftButtonText: "Cancel", rightButtonText: "Save", buttonSize: .init(width: 160, height: 48), onPressLeftButton: {}, onPressRightButton: {}, rightButtonDisabled: false)
  }
}
