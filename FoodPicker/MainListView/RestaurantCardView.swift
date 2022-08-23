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
    VStack(alignment: .leading, spacing: 8) {
      CachedAsyncImage(url: presenter.imageUrl, content: { phase in
        switch phase {
        case .empty:
          Color.gray.opacity(0.5)
        case .success(let image):
          image.resizable()
        case .failure(_):
          Image("spinActive")
        @unknown default:
          Image("spinActive")
        }
      })
      .aspectRatio(contentMode: .fill)
      .frame(height: 128)
      .overlay(alignment: .topTrailing) {
        ActionButton(imageName: presenter.actionButtonImage) {
          selectButtonOnPress()
        }
        .animation(.easeInOut(duration: 0.25), value: presenter.actionButtonImage)
      }
      .cornerRadius(16)
      .padding(.top, 8)
      .padding(.horizontal, 8)

      VStack(alignment: .leading, spacing: 6) {
        VStack(alignment: .leading, spacing: 6) {
          HStack {
            VStack(alignment: .leading, spacing: 6) {
              Text(presenter.name)
                .en16ArialBold()
              Text(presenter.openOrCloseString)
                .en14ArialBold()
                .foregroundColor(presenter.openOrCloseColor)
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
          Text(presenter.thirdRowString).en14Arial().foregroundColor(Color.gray.opacity(0.7))
        }
        HStack(spacing: 4, content: {
          Text("★").foregroundColor(Color.yellow)
          Text("\(presenter.ratingWithOneDecimal)").en14Arial()
          Text("\("\(presenter.reviewCount)")").en14Arial()
            .foregroundColor(Color.gray.opacity(0.7))
          Spacer()
        })
      }
      .padding(.leading, 16)
      .padding(.trailing, 8)
    }
    .frame(width: 280, height: 250)
    .roundedViewWithShadow(cornerRadius: 16,
                           backgroundColor: Color.white,
                           shadowColor: Color.gray.opacity(0.3),
                           shadowRadius: 3)
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
