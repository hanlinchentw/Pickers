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
	var distance: Distance
  var onClickHeart: () -> Void
  var onClickSelect: () -> Void

  var body: some View {
    HStack {
      HStack {
        KFImage(viewModel.imageUrl)
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
		let distance = distance.description
		str = str.isEmpty ? distance : str + " \u{00B7} " + distance

    if let price = viewModel.price {
      str += " \u{00B7} " + price
    }
    return str
  }
}

#Preview {
	var dummyBusiness: Business {
		.init(
			id: UUID().uuidString,
			name: "Apple",
			rating: 5.0,
			price: "$$$",
			imageUrl: Constants.defaultImageURL,
			distance: 125,
			isClosed: false,
			categories: [.init(title: "Food")],
			reviewCount: 12555,
			coordinates: .init(latitude: 23.5, longitude: 123.2),
			location: Location(displayAddress: ["EmeryVile"])
		)
	}

  ExploreItemView(
		viewModel: .init(business: dummyBusiness),
		distance: .meter(500),
    onClickHeart: {
      print("onClickHeart")
    },
    onClickSelect: {
      print("onClickSelect")
    }
  )
}
