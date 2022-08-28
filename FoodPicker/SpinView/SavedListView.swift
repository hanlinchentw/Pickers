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
            ForEach(savedLists) { list in
              ListCardView(list: list)
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
      Text("Saved List").en16Bold()
    )
  }
}
