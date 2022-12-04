//
//  EditNameContainer.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/15.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct EditNameContainer: View {
  @Binding var editListName: String

  var isListNameEmpty: Bool {
    return editListName.isEmpty
  }

  var numOfCharDisplayText: String {
    return "\(editListName.count) / 20"
  }

  var body: some View {
    VStack {
      TextField("", text: $editListName)
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
        .height(40)
        .background(
          RoundedRectangle(cornerRadius: 12)
            .stroke(isListNameEmpty ? .red : .gray, lineWidth: 0.3)
        )

      HStack {
        if isListNameEmpty {
          Text("List can't not be empty").en14().foregroundColor(.red)
        }
        Spacer()
        Text(numOfCharDisplayText)
          .en12()
          .foregroundColor(.gray.opacity(0.8))
      }
    }
    .padding(.horizontal, 16)
  }
}

struct EditNameContainer_Previews: PreviewProvider {
  static var previews: some View {
    EditNameContainer(editListName: .constant("Name"))
  }
}
