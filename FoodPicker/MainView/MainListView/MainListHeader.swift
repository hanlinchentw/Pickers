//
//  SearchFieldContainer.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/13.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct MainListHeader: View {
  @EnvironmentObject var coordinator: MainCoordinator
  @Environment(\.presentationMode) var presentationMode
  @Binding var searchText: String
  @Binding var isSearching: Bool

  var body: some View {
    HStack(alignment: .center) {
      TextField("", text: $searchText, onEditingChanged: { changed in
        isSearching = changed
      })
        .placeholder(when: searchText.isEmpty) {
          HStack {
            Image(systemName: "magnifyingglass")
            Text("Search in my favorite")
          }
          .foregroundColor(.gray.opacity(0.5))
        }
        .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0))
        .height(40)
        .roundedViewWithShadow(cornerRadius: 8,
                               backgroundColor: Color.white,
                               shadowColor: Color.gray.opacity(0.3),
                               shadowRadius: 3)

      Button {
        coordinator.presentMapView()
      } label: {
        Image(systemName: "map.circle.fill")
          .frame(width: 40, height: 40)
          .foregroundColor(.butterScotch)
          .roundedViewWithShadow(cornerRadius: 8,
                                 backgroundColor: Color.white,
                                 shadowColor: Color.gray.opacity(0.3),
                                 shadowRadius: 3)
      }
    }
    .padding(.top, 16)
    .padding(.leading, 16)
    .padding(.trailing, 8)
  }
}

struct SearchFieldContainer_Previews: PreviewProvider {
  static var previews: some View {
    MainListHeader(searchText: .constant(""), isSearching: .constant(false))
  }
}
