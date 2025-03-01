//
//  PocketView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/6/28.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import SwiftData
import SwiftUI

struct PocketView: View {
  @Environment(\.modelContext) var context
  @Query var favoritePlaces: [SDPlaceModel]
  @Query var folders: [SDFolder]

  var viewModels: [PlaceViewModel] {
    favoritePlaces.map {
      PlaceViewModel(
        id: $0.id,
        name: $0.name,
        price: $0.price,
        rating: $0.rating,
        reviewCount: $0.reviewCount,
        category: $0.category,
        imageUrl: $0.imageUrl,
        latitude: $0.latitude,
        longitude: $0.longitude,
        isSelected: false,
        isLiked: false
      )
    }
  }

  var body: some View {
    ZStack {
      Color(.systemBackground).ignoresSafeArea()
      VStack {
        List {
          if !favoritePlaces.isEmpty {
            Text("Favorite")
              .en16Bold()
              .foregroundStyle(Color.gray6)
            ForEach(viewModels) {
              ExploreItemView(viewModel: $0) {
              } onClickSelect: {
              }
            }
            .listRowSeparator(.hidden)
          }
        }
        .selectionDisabled()
        .listStyle(.plain)
        .scrollIndicators(.hidden)
      }
    }
  }
}

#Preview {
  PocketView()
    .dummySwiftDataModelContainer()
}
