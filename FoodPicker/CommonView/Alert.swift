//
//  Alert.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/21.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct Alert<Content: View>: View {
  var title: String?
  var rightButtonText: String?
  var leftButtonText: String?
  
  var rightButtonOnPress: () -> Void
  var leftButtonOnPress: () -> Void
  
  var content: (() -> Content)?
  var body: some View {
    ZStack {
      Color.black.opacity(0.6)
        .onTapGesture {
          leftButtonOnPress()
        }
      VStack(alignment: .center) {
        Spacer()
        if let title = title {
          Text(title).en16ArialBold()
            .foregroundColor(.butterScotch)
            .padding(.horizontal, 32)
            .multilineTextAlignment(.center)
        }
        Spacer()
        if let content = content { content() }
        Spacer()
        HStack {
          Spacer()
          if let leftButtonText = leftButtonText {
            Button {
              leftButtonOnPress()
            } label: {
              Text(leftButtonText)
                .foregroundColor(.gray)
            }
          }
          Spacer()
          if let rightButtonText = rightButtonText {
            Button {
              rightButtonOnPress()
            } label: {
              Text(rightButtonText)
                .foregroundColor(.gray)
            }
          }
          Spacer()
        }
        .padding(.bottom, 24)
      }
      .background(Color.white)
      .frame(height: 240)
      .cornerRadius(24)
      .padding(.horizontal, 40)
    }
    .ignoresSafeArea()
  }
}

struct Alert_Previews: PreviewProvider {
  static var previews: some View {
    Alert(
      title: "Alert",
      rightButtonText: "OK",
      leftButtonText: "Cancel",
      rightButtonOnPress: {
        debugPrint("rightButton tapped")
      },
      leftButtonOnPress: {
        debugPrint("leftButton tapped")
      },
      content: {
        Text("Content").font(.body)
      }
    )
  }
}


