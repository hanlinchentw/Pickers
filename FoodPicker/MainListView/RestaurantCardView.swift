//
//  RestaurantCardView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/12.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct RestaurantCardView: View {
  @Binding var restaurant: RestaurantViewObject
  @EnvironmentObject var locationService: LocationService

  var openOrCloseString: String {
    guard let isClosed = restaurant.isClosed else {
      return "Close"
    }
    return isClosed ? "Closed" : "Open"
  }

  var distance : Int {
    locationService.getDistanceFromCurrentLocation(restaurant.coordinates.latitude, restaurant.coordinates.longitude)
  }

  var thirdRowString: String {
    "\(restaurant.price)・\(restaurant.businessCategory)・\(distance) m"
  }

  var ratingWithOneDecimal: String {
    "\((restaurant.rating * 10).rounded()/10)"
  }

  var body: some View {
    VStack {
      AsyncImage(url: restaurant.imageUrl) { phase in
          switch phase {
          case .empty:
              Color.gray.opacity(0.5)
          case .success(let image):
              image
              .resizable()
          case .failure(_):
              Image(systemName: "exclamationmark.icloud")
          @unknown default:
              Image(systemName: "exclamationmark.icloud")
          }
      }
      .aspectRatio(contentMode: .fill)
      .frame(width: 264, height: 128)
      .cornerRadius(16)
      .padding(.top, 8)
      .padding(.horizontal, 8)

      VStack(alignment: .leading, spacing: 6) {
        VStack(alignment: .leading, spacing: 6) {
          Text(restaurant.name).en16ArialBold()
          Text(openOrCloseString).en14ArialBold().foregroundColor(restaurant.isClosed != nil && restaurant.isClosed! ? Color.red : Color.green)
          Text(thirdRowString).en14Arial().foregroundColor(Color.gray.opacity(0.7))
        }
        HStack(spacing: 4, content: {
          Text("★").foregroundColor(Color.yellow)
          Text("\(ratingWithOneDecimal)").en14Arial()
          Text("\("(\(restaurant.reviewCount))")").en14Arial().foregroundColor(Color.gray.opacity(0.7))
          Spacer()
        })
      }
      .padding(.top, 4)
      .padding(.horizontal, 16)
      Spacer()
    }
    .frame(width: 280, height: 242)
    .roundedViewWithShadow(cornerRadius: 16,
                          backgroundColor: Color.white,
                          shadowColor: Color.gray.opacity(0.5),
                           shadowRadius: 7)
  }
}
