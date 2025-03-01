//
//  TabBarView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/6/28.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import RswiftResources
import SwiftUI

struct TabBarView: View {
  @Binding var selectedTab: Int
  var selectedItemCount: Int

  var body: some View {
    HStack {
      Spacer().frame(width: 36)

      TabItemView(isActive: selectedTab == TabItems.explore.rawValue) {
        selectedTab = TabItems.explore.rawValue
      } image: {
        makeItemImage(R.image.homeUnselectedS.name)
      } selectedImage: {
        makeItemImage(R.image.homeSelectedS.name)
      }

      Spacer()

      TabItemView(isActive: selectedTab == TabItems.wheel.rawValue) {
        selectedTab = TabItems.wheel.rawValue
      } image: {
        makeSpinTabItem(focused: false)
      } selectedImage: {
        makeSpinTabItem(focused: true)
      }

      Spacer()

      TabItemView(isActive: selectedTab == TabItems.pocket.rawValue) {
        selectedTab = TabItems.pocket.rawValue
      } image: {
        makeItemImage(R.image.list.name)
      } selectedImage: {
        makeItemImage(R.image.listFilled.name)
      }

      Spacer().frame(width: 36)
    }
    .frame(height: 100)
    .clipped()
    .cornerRadius(36)
    .background(
      Color.white // any non-transparent background
        .cornerRadius(36, corners: [.topLeft, .topRight])
        .shadow(color: Color.gray6.opacity(0.3), radius: 8, x: 0, y: -8)
    )
    .ignoresSafeArea()
  }

  func makeSpinTabItem(focused _: Bool) -> some View {
    ZStack {
      Circle()
        .foregroundColor(.butterScotch)
      if selectedItemCount == 0 {
        Image(R.image.logoW)
          .resizable()
          .frame(width: 40, height: 40)
      } else {
        Text("\(selectedItemCount)")
          .foregroundColor(.white)
          .en16Bold()
      }
    }
    .frame(width: 54, height: 54)
  }

  func makeItemImage(_ imageName: String, size: CGFloat = 24) -> some View {
    Image(imageName)
      .renderingMode(.original)
      .resizable()
      .frame(width: size, height: size)
      .padding(.horizontal)
      .padding(.vertical, 4)
  }
}

struct TabBarView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      Spacer()
      TabBarView(selectedTab: .constant(0), selectedItemCount: 1)
    }
    .ignoresSafeArea()
  }
}
