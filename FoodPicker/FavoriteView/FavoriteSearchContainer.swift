//
//  FavoriteSearchContainer.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/21.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct FavoriteSearchContainer: View {
  @Binding var inputText: String
  var isEditing: Bool

  var body: some View {
    ZStack {
      Text("Memories are the only things left after deletion")
        .foregroundColor(Color.gray.opacity(0.4))
        .en16ArialBold()
        .multilineTextAlignment(.center)
        .height(40)
      TextField("", text: $inputText)
        .placeholder(when: inputText.isEmpty) {
          HStack {
            Image("icnSearchSmall")
            Text("Search in my favorite")
              .en14Arial()
              .foregroundColor(.gray.opacity(0.5))
          }
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
        .height(40)
        .roundedViewWithShadow(cornerRadius: 8,
                               backgroundColor: Color.white,
                               shadowColor: Color.gray.opacity(0.1),
                               shadowRadius: 1)
        .animation(.easeInOut, value: isEditing)
        .if(isEditing, transform: { $0.opacity(0) })
    }
    .padding(.top, 8)
    .padding(.horizontal, 16)
  }
}

struct FavoriteSearchContainer_Previews: PreviewProvider {
  static var previews: some View {
    FavoriteSearchContainer(inputText: .constant(""), isEditing: true)
  }
}
