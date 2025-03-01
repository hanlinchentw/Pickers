//
//  ExploreMainScrollView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/1/12.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import SwiftUI

struct ExploreMainScrollView: View {
  var viewModels: [PlaceViewModel]
  var isLoading: Bool
  var onClickHeart: (PlaceViewModel) -> Void
  var onClickSelect: (PlaceViewModel) -> Void
  var loadMoreIfNeeded: @Sendable () async -> Void
  var shouldLoadMore: (Int) -> Bool
  var refresh: @Sendable () async -> Void
}

extension ExploreMainScrollView {
  var body: some View {
    VStack(alignment: .leading) {
      List {
        ForEach(viewModels.indices, id: \.self) { index in
          VStack {
            ExploreItemView(
              viewModel: viewModels[index],
              onClickHeart: {
                onClickHeart(viewModels[index])
              },
              onClickSelect: {
                onClickSelect(viewModels[index])
              }
            )
            .padding(.vertical)
            if shouldLoadMore(index) {
              ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .butterScotch))
                .scaleEffect(1.2, anchor: .center)
                .padding(.vertical)
                .task {
                  await loadMoreIfNeeded()
                }
            }
          }
        }
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
      }
      .refreshable(action: refresh)
      .selectionDisabled()
      .listStyle(.plain)
      .scrollIndicators(.hidden)
    }
  }
}

#Preview {
  ExploreMainScrollView(
    viewModels: [.dummy, .dummy, .dummy],
    isLoading: false,
    onClickHeart: {
      print($0)
    }, onClickSelect: {
      print($0)
    }, loadMoreIfNeeded: {
      print("Load more")
    }, shouldLoadMore: { _ in
      false
    }
  ) {
  }
}
