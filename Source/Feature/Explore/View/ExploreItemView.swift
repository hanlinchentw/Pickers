//
//  ExploreItemView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/1/11.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import CoreLocation
import Kingfisher
import SwiftUI

struct ExploreItemView: View {
  var viewModel: PlaceViewModel
  var onClickHeart: () -> Void
  var onClickSelect: () -> Void

  var body: some View {
    HStack {
      HStack {
        KFImage(URL(string: viewModel.imageUrl ?? ""))
          .placeholder { _ in
            Color.gray4
          }
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 80, height: 80)
          .cornerRadius(16)
        VStack(alignment: .leading) {
          Text(viewModel.name).medium(size: 17)
          Spacer()
          Text(subTitle)
            .light(size: 15)
            .foregroundStyle(Color.gray5)
          Spacer()
          Text(viewModel.category)
            .light(size: 15)
            .foregroundStyle(Color.gray5)
        }
        .padding(.leading, 8)
        Spacer()
        Button(action: onClickSelect, label: {
          Image(viewModel.isSelected ? "icnOvalSelected" : "addL")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40)
            .foregroundColor(.white)
        })
        .buttonStyle(.plain)
      }
    }
    .frame(height: 80)
    .swipeActions {
      Button(action: onClickHeart, label: {
        Text("Collect")
      })
      .buttonStyle(.plain)
    }
  }

  var subTitle: String {
    var str = String()
    if let rating = viewModel.rating {
      str += String(rating)
    }
    if let reviewCount = viewModel.reviewCount {
      str += " (\(String(reviewCount))+)"
    }
    if let distance = viewModel.distance?.description {
      str = str.isEmpty ? distance : str + " \u{00B7} " + distance
    }
    if let price = viewModel.price {
      str += " \u{00B7} " + price
    }
    return str
  }
}

#Preview {
  ExploreItemView(
    viewModel: .dummy,
    onClickHeart: {
      print("onClickHeart")
    },
    onClickSelect: {
      print("onClickSelect")
    }
  )
}
