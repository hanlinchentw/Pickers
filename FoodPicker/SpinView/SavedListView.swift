//
//  SavedListView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/27.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct SavedListView: View {
  @Environment(\.presentationMode) var presentationMode
  @Environment(\.managedObjectContext) var viewContext
  @FetchRequest(sortDescriptors: []) var savedLists: FetchedResults<List>

  var body: some View {
    ZStack {
      Color.listViewBackground.ignoresSafeArea()
      VStack(alignment: .center) {
        SavedListHeader(back: {
          presentationMode.wrappedValue.dismiss()
        })

        ScrollView(.vertical, showsIndicators: false) {
          VStack {
            ForEach(MockedList.mock_lists) { list in
              HStack {
                VStack(alignment: .leading) {
                  VStack(alignment: .leading, spacing: 8) {
                    Text(list.name)
                      .en16ArialBold()
                    Text(list.date)
                      .en14Arial()
                      .foregroundColor(.gray)
                  }
                  Spacer()
                  Text("3 restaurants")
                    .en14Arial()
                }
                .padding(.vertical, 16)
                .padding(.leading, 16)

                Spacer()

                VStack() {
                  Image("icnMoreThreeDot")
                    .frame(width: 40, height: 40)
                  Spacer()
                  Image("icnArrowUp")
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
            }
          }
        }
        .padding(.top, 16)
        Spacer()
      }
    }
    .navigationBarHidden(true)
  }
}

struct SavedListView_Previews: PreviewProvider {
  static var previews: some View {
    SavedListView()
  }
}

struct SavedListHeader: View {
  var back: () -> Void

  var body: some View {
    HStack {
      RoundedRectangle(cornerRadius: 22)
        .fill(Color.white)
        .overlay(Image("icnArrowBack"))
        .frame(width: 44, height: 44)
        .padding(.leading, 8)
        .onTapGesture {
          back()
        }
      Spacer()
    }
    .overlay(
      Text("Saved List").en16ArialBold()
    )
  }
}
