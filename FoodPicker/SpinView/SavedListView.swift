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
  @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var savedLists: FetchedResults<List>
  
  var applyList: (_ list: List) -> Void
  
  var body: some View {
    NavigationView {
      ZStack {
        Color.listViewBackground.ignoresSafeArea()
        
        VStack(alignment: .center) {
          SavedListHeader(
            back: {
              presentationMode.wrappedValue.dismiss()
            }
          )
          ScrollView(.vertical, showsIndicators: false) {
            VStack {
              ForEach(savedLists, id: \.self) { list in
                ListCardView(list: list)
                  .onTapGesture {
                    applyList(list)
                    presentationMode.wrappedValue.dismiss()
                  }
              }
            }
          }
          .safeAreaInset(edge: .top) { Spacer().height(20) }
          Spacer()
        }
      }
      .ignoresSafeArea()
      .navigationBarHidden(true)
    }
  }
}

struct SavedListView_Previews: PreviewProvider {
  static var previews: some View {
    SavedListView { list in
      
    }
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
    .padding(.top, SafeAreaUtils.top)
  }
}
