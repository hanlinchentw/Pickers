//
//  ExploreHeaderView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/1/12.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import SwiftUI

struct ExploreHeaderView: View {
  var address: String?
  @Binding var browseMode: BrowseMode
  @Binding var searchText: String
  var onClickFilterButton: () -> Void

  var body: some View {
    VStack {
      if let address {
        HStack {
          addressView(address: address)
          Spacer()
          Button {
            withAnimation {
              browseMode = browseMode.toggle()
            }
          } label: {
            Image(browseMode == .map ? "search" : "map")
              .resizable()
              .scaledToFit()
              .frame(width: 28, height: 28)
              .tint(.butterScotch)
          }
          .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
      }
      searchBar.padding(.horizontal, 16)
    }
  }

  var searchBar: some View {
    HStack {
      TextField("", text: $searchText)
        .placeholder(when: searchText.isEmpty) {
          HStack {
            Image(systemName: "magnifyingglass")
            Text("Search Picker")
              .semibold(size: 15)
          }
          .padding(.horizontal, 20)
          .padding(.vertical, 12)
          .foregroundStyle(Color.gray6)
        }
        .background(Color.gray95)
        .height(48)
        .cornerRadius(24)
      Spacer()
      Button(
        action: {
          onClickFilterButton()
        }, label: {
          Image("filter")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 18)
        }
      )
    }
  }

  @ViewBuilder
  func addressView(address: String) -> some View {
    HStack {
      VStack(alignment: .leading, spacing: 6) {
        Text("Current At:")
          .semibold(size: 13)
        HStack {
          Text(address)
            .bold(size: 15)
          Button(
            action: {
            }, label: {
              Image(systemName: "chevron.down")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12)
            }
          )
          .buttonStyle(.plain)
        }
      }
      Spacer()
    }
  }
}

#Preview {
  ZStack {
    Color.clear
    ExploreHeaderView(
      address: "中山北路, 43 號",
      browseMode: .constant(.list),
      searchText: .constant(String()),
      onClickFilterButton: {}
    )
  }
}
