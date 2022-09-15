//
//  EditListView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/30.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI
import Combine

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
          EditNameContainer(editListName: $viewModel.editListName)
          EditListContainer(list: $viewModel.list)
        }
        .padding(.vertical, 16)
        .background(Color.white)

        TwoHorizontalButton(
          leftButtonText: "Cancel",
          rightButtonText: "Save",
          buttonSize: .init(width: 160, height: 48),
          onPressLeftButton: {
            //TODO: Cancel
          },
          onPressRightButton: {
            //TODO: Save
          }
        )
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
