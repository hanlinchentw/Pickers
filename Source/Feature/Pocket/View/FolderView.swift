//
//  FolderView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/4/6.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import SwiftData
import SwiftUI

struct FolderView: View {
  var folders: [SDFolder]

  var body: some View {
    LazyHGrid(rows: [
      GridItem(.fixed(120)),
      GridItem(.fixed(120))
    ], spacing: 32, content: {
      ForEach(folders) { folder in
        VStack {
          Image(systemName: "folder.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 72)
            .foregroundStyle(Color.butterScotch.opacity(0.5))
          Text(folder.name)
        }
      }
    })
  }
}

#Preview {
  FolderView(folders: [.dummy])
}
