//
//  FavoriteEditButtonContainer.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/21.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct FavoriteEditButtonContainer: View {
  @Binding var isEditing: Bool

  var body: some View {
    HStack {
      Spacer()
      Button {
        isEditing.toggle()
      } label: {
        if isEditing {
          Text("Finish").en14ArialBold().foregroundColor(.freshGreen)
          Image("icnSuccessS")
        } else {
          Text("Edit").en14Arial().foregroundColor(.black)
          Image("icnEditSmall")
        }
      }
    }
    .padding(.top, 16)
    .padding(.horizontal, 16)
  }
}
