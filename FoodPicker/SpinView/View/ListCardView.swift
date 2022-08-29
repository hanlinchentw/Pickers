//
//  ListCardView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/28.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct ListCardView: View {
  var viewModel: ListCardViewModel
  @State var isExpand: Bool = false

  init(list: List) {
    self.viewModel = ListCardViewModel(list: list)
  }

  var body: some View {
    VStack {
      HStack {
        VStack(alignment: .leading) {
          VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.name).en16Bold()
            Text(viewModel.date).en14()
              .foregroundColor(.gray)
          }
          Spacer()
          Text(viewModel.numOfRestaurantsDisplayText).en14()
        }
        .padding(.vertical, 16)
        .padding(.leading, 16)

        Spacer()

        VStack() {
          Image("icnMoreThreeDot")
            .frame(width: 40, height: 40)
          Spacer()
          Button {
            withAnimation {
              isExpand.toggle()
            }
          } label: {
            isExpand ? Image("icnArrowUp") : Image("icnArrowDown")
          }
          .animation(.easeInOut, value: isExpand)
          .frame(width: 40, height: 40)
        }
        .padding(.vertical, 8)
        .padding(.trailing, 8)
      }
      .frame(height: 116)
      .roundedViewWithShadow(
        cornerRadius: 16,
        backgroundColor: .white,
        shadowColor: .gray.opacity(0.5),
        shadowRadius: 8
      )
      .padding(.bottom, 8)
      .padding(.horizontal, 8)
      .zIndex(1)

      if isExpand {
        VStack {
          ForEach(0 ..< viewModel.numOfRestaurants, id: \.self) { index in
            let restaurant = viewModel.getRestaurantByIndex(index)
            let presenter = RestaurantPresenter(restaurant: restaurant, actionButtonMode: .none)
            RestaurantListItemView(presenter: presenter) {
            }
          }
        }
        .height(CGFloat(viewModel.numOfRestaurants * 120))
        .zIndex(0)
      }
    }
  }
}

struct ListCardView_Previews: PreviewProvider {
  static var previews: some View {
    ListCardView(list: MockedList.mock_list_1)
  }
}
