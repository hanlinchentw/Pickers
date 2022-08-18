//
//  RestaurantListItemView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/14.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct RestaurantListItemView: View {
  var presenter: RestaurantPresenter

  var selectButtonOnPress: () -> Void

  init(presenter: RestaurantPresenter, selectedButtonOnPress: @escaping () -> Void) {
    self.presenter = presenter
    self.selectButtonOnPress = selectedButtonOnPress
  }
  var body: some View {
    HStack {
      AsyncImage(url: presenter.imageUrl) { phase in
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
      .frame(width: 93, height: 93)
      .cornerRadius(16)
      .padding(.top, 8)
      .padding(.horizontal, 8)
      VStack(alignment: .leading) {
        VStack(alignment: .leading, spacing: 6) {
          Text(presenter.name).en16ArialBold()
          Text(presenter.thirdRowString).en14Arial()
        }
        HStack(spacing: 4, content: {
          Text("★").foregroundColor(Color.yellow)
          Text("\(presenter.ratingWithOneDecimal)").en14Arial()
          Text("\("(\(presenter.reviewCount))")").en14Arial()
            .foregroundColor(Color.gray.opacity(0.7))
          Spacer()
        })
      }
      .padding(.leading, 6)
      Button {
        selectButtonOnPress()
      } label: {
        Image(presenter.selectButtonImage)
          .shadow(color: Color.gray.opacity(0.25), radius: 3, x: 0, y: 0)
      }
    }
  }
}
