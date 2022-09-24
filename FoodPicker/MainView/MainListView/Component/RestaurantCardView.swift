//
//  RestaurantCardView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/12.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct RestaurantCardView: View {
  var presenter:  RestaurantPresenter
  var selectButtonOnPress: () -> Void
  var likeButtonOnPress: () -> Void

  init(presenter: RestaurantPresenter, _ selectButtonOnPress: @escaping () -> Void, _ likeButtonOnPress: @escaping () -> Void) {
    self.presenter = presenter
    self.selectButtonOnPress = selectButtonOnPress
    self.likeButtonOnPress = likeButtonOnPress
  }

  var body: some View {
    VStack(alignment: .leading) {
      CachedAsyncImage(url: presenter.imageUrl, content: { phase in
        switch phase {
        case .empty:
          Color.gray.opacity(0.5)
        case .success(let image):
          image.resizable()
        case .failure(_):
          Image(systemName: "photo.artframe")
        @unknown default:
					Image(systemName: "photo.artframe")
        }
      })
      .aspectRatio(contentMode: .fill)
      .frame(width: 264, height: 128)
      .overlay(alignment: .topTrailing) {
        ActionButton(imageName: presenter.actionButtonImage) {
          selectButtonOnPress()
        }
        .animation(.easeInOut(duration: 0.25), value: presenter.actionButtonImage)
      }
      .cornerRadius(16)
      .padding(.top, 8)
      .padding(.horizontal, 8)

      Spacer()

      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 4) {
          Text(presenter.name)
            .en16Bold()
          Text(presenter.openOrCloseString)
            .en14Bold()
            .foregroundColor(presenter.openOrCloseColor)
          Text(presenter.priceCategoryDistanceText).en14().foregroundColor(Color.gray.opacity(0.7))
          HStack(spacing: 4, content: {
            Text("★").foregroundColor(Color.yellow)
            Text("\(presenter.ratingWithOneDecimal)").en14()
            Text("\("\(presenter.reviewCount)")").en14()
              .foregroundColor(Color.gray.opacity(0.7))
            Spacer()
          })
        }
        Spacer()
        ActionButton(imageName: presenter.likeButtonImage) {
          likeButtonOnPress()
        }
        .animation(.easeInOut(duration: 0.25), value: presenter.likeButtonImage)
        .clipped()
        .aspectRatio(contentMode: .fit)
        .frame(width: 48, height: 48)
      }
      .padding(.leading, 16)
      .padding(.trailing, 8)
      .padding(.bottom, 12)
    }
    .frame(width: 280, height: 240)
    .roundedWithShadow(cornerRadius: 16)
  }
}

struct ActionButton: View {
  var imageName: String
  var onPress: () -> Void
  var body: some View {
    Button {
      onPress()
    } label: {
      Image(imageName)
    }
  }
}
