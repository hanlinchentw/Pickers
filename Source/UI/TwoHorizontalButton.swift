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

  var rightButtonDisabled: Bool = false

  let buttonSize: CGSize

  var onPressLeftButton: () -> Void
  var onPressRightButton: () -> Void

  var body: some View {
    HStack {
      Spacer()
      Button {
        onPressLeftButton()
      } label: {
        Text(leftButtonText)
          .en16()
          .foregroundColor(.black)
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
      .background(
        RoundedRectangle(cornerRadius: 16)
          .fill(rightButtonDisabled ? Color.gray : Color.black)
      )
      .disabled(rightButtonDisabled)
      Spacer()
    }
    .padding(.bottom, 24)
  }
}

struct TwoHorizontalButton_Previews: PreviewProvider {
  static var previews: some View {
    TwoHorizontalButton(leftButtonText: "Cancel", rightButtonText: "Save", rightButtonDisabled: false, buttonSize: .init(width: 160, height: 48), onPressLeftButton: {}, onPressRightButton: {})
  }
}
