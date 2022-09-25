//
//  Alert.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/21.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct AlertPresentationModel {
  var title: String? = nil
	var content: String? = nil

  var rightButtonText: String? = nil
  var leftButtonText: String? = nil

  var rightButtonOnPress: () -> Void
  var leftButtonOnPress: (() -> Void)? = nil

  var rightButtonColor: Color = .black
  var leftButtonColor: Color = .black
}

struct Alert: View {
  @Environment(\.presentationMode) var presentaionMode

  var model: AlertPresentationModel

  var body: some View {
    ZStack {
      Color.black.opacity(0.6)
        .onTapGesture {
          if let onPress = model.leftButtonOnPress {
            onPress()
          } else {
            presentaionMode.wrappedValue.dismiss()
          }
        }
      VStack(alignment: .center) {
        if let title = model.title {
          Text(title).en18Bold()
            .foregroundColor(.butterScotch)
            .padding(.horizontal, 28)
            .multilineTextAlignment(.center)
            .padding(.top, 24)
        }
				if let content = model.content {
          Text(content)
						.en14()
						.foregroundColor(.black)
            .padding(.horizontal, 28)
						.multilineTextAlignment(.center)
            .padding(.top, 8)
        }
        HStack {
          Spacer()
          if let leftButtonText = model.leftButtonText {
            Button {
              if let onPress = model.leftButtonOnPress {
                onPress()
              } else {
                presentaionMode.wrappedValue.dismiss()
              }
            } label: {
              Text(leftButtonText)
                .foregroundColor(model.leftButtonColor)
            }
          }
          Spacer()
          if let rightButtonText = model.rightButtonText {
            Button {
              model.rightButtonOnPress()
              presentaionMode.wrappedValue.dismiss()
            } label: {
              Text(rightButtonText)
                .foregroundColor(model.rightButtonColor)
            }
          }
          Spacer()
        }
        .padding(.top, 16)
        .padding(.bottom, 16)
      }
      .background(Color.white)
      .cornerRadius(24)
      .frame(width: 280)
    }
    .ignoresSafeArea()
  }
}

struct Alert_Previews<Content: View>: PreviewProvider {
  static var previews: some View {
		Alert(model: .init(title: "", content: "",rightButtonText: "", leftButtonText: "", rightButtonOnPress: {

    }, leftButtonOnPress: {

    }))
  }
}


