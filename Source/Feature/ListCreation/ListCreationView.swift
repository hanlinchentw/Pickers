//
//  ListCreationView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/8/18.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import SwiftUI

struct Item: Identifiable {
  let id = UUID()
  let name: String
}

struct ListCreationView: View {
  @State private var items: [Item] = []
  @State private var newItemName: String = ""

  var body: some View {
    VStack(alignment: .leading) {
      TextField("Enter item name", text: $newItemName)
        .textFieldStyle(.roundedBorder)
        .padding(.horizontal)
        .font(.largeTitle)
        .padding()

      HStack {
        TextField("Enter item name", text: $newItemName)
          .textFieldStyle(.roundedBorder)
          .padding(.horizontal)

        Button(action: {
          addItem()
        }) {
          Image(systemName: "plus")
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Circle())
        }
        .padding(.trailing)
      }

      List(items) { item in
        Text(item.name)
      }
    }
  }

  private func addItem() {
    guard !newItemName.isEmpty else { return }
    let newItem = Item(name: newItemName)
    items.append(newItem)
    newItemName = ""
  }
}

#Preview {
  ListCreationView()
}
