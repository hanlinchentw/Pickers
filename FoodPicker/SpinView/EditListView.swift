//
//  EditListView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/30.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI
import Combine

class EditListViewModel: ObservableObject {
  @Published var list: List
  @Published var editListName: String = ""

  init(list: List) {
    self.list = list
    self.editListName = list.name
  }

  var numOfCharDisplayText: String {
    return "\(editListName.count) / 20"
  }

  var numOfRestaurantsDisplayText: String {
    return "\(list.restaurants.count) restaurants"
  }

  var isListNameValid: Bool {
    return !editListName.isEmpty
  }
}

struct EditListView: View {
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var viewModel: EditListViewModel

  var body: some View {
    ZStack {
      Color.listViewBackground
      VStack {
        EditListHeader {
          presentationMode.wrappedValue.dismiss()
        }

        VStack {
          VStack {
            TextField("", text: $viewModel.editListName)
              .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
              .height(40)
              .background(
                RoundedRectangle(cornerRadius: 12)
                  .stroke(viewModel.isListNameValid ? .gray : .red, lineWidth: 0.3)
              )

            HStack {
              if !viewModel.isListNameValid {
                Text("List name can't be empty.").en14().foregroundColor(.red)
              }
              Spacer()
              Text(viewModel.numOfCharDisplayText)
                .en12()
                .foregroundColor(.gray.opacity(0.8))
            }
          }

          .padding(.horizontal, 16)
          HStack {
            Text(viewModel.numOfRestaurantsDisplayText)
              .en14()
              .foregroundColor(.black.opacity(0.8))
              .padding(.leading, 16)
            Spacer()
          }
          .padding(.top, 12)

          ScrollView {
            ForEach(0 ..< viewModel.list.restaurants.count, id: \.self) { index in
              let restaurant = Array(viewModel.list.restaurants)[index] as? Restaurant
              let viewObject = RestaurantViewObject(restaurant: restaurant!)
              let presenter = RestaurantPresenter(restaurant: viewObject, actionButtonMode: .none)
              RestaurantListItemView(presenter: presenter) {}
            }
          }
        }
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(16)

        HStack {
          Spacer()
          Button {

          } label: {
            Text("Cancel")
              .foregroundColor(.black)
              .en16()
          }
          .frame(width: 160, height: 48)
          .background(RoundedRectangle(cornerRadius: 16).stroke(.gray))
          Spacer()
          Button {

          } label: {
            Text("Save")
              .foregroundColor(.white)
              .en16Bold()
          }
          .frame(width: 160, height: 48)
          .background(RoundedRectangle(cornerRadius: 16).fill(.black))

          Spacer()
        }
        .padding(.bottom, 24)
        Spacer()
      }
      .padding(.top, SafeAreaUtils.top)
      .onTapGesture {
        UIResponder.resign()
      }
    }
    .ignoresSafeArea()
    .navigationBarHidden(true)
  }
}

struct EditListView_Previews: PreviewProvider {
  static var previews: some View {
    EditListView(viewModel: EditListViewModel(list: MockedList.mock_list_1))
  }
}

private struct EditListHeader: View {
  var onPress: () -> Void

  var body: some View {
    HStack {
      RoundedRectangle(cornerRadius: 22)
        .fill(Color.white)
        .overlay(Image("icnArrowBack"))
        .frame(width: 44, height: 44)
        .padding(.leading, 8)
        .onTapGesture {
          onPress()
        }
      Spacer()
    }
    .overlay(
      Text("Edit List").en16Bold()
    )
  }
}
