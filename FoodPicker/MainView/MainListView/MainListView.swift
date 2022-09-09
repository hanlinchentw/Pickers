//
//  MainListView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/12.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI
import CoreData

enum LoadingState {
  case idle
  case loading
  case loaded
  case empty
  case error
}
typealias ItemOnPress = (_ id: String) -> Void
struct MainListView: View {
  @EnvironmentObject var coordinator: MainCoordinator
  @Environment(\.managedObjectContext) private var viewContext

  @State private var inputText: String = ""

  init() {
    let newAppearance = UITabBarAppearance()
    newAppearance.configureWithOpaqueBackground()
    newAppearance.backgroundColor = UIColor(Color.white)
    UITabBar.appearance().standardAppearance = newAppearance
  }

  var body: some View {
    NavigationView {
      ZStack {
        Color.listViewBackground.ignoresSafeArea()
        ScrollView(.vertical, showsIndicators: false) {
          VStack(spacing: 24) {
            SearchFieldContainer(inputText: inputText).environmentObject(coordinator)

            HorizontalSectionContainer()
              .environment(\.managedObjectContext, viewContext)
              .environmentObject(coordinator)

            VerticalListContainer()
              .environment(\.managedObjectContext, viewContext)
              .environmentObject(coordinator)
          }
        }
      }
      .navigationBarHidden(true)
      Spacer()
    }
    .onTapGesture {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
  }
}

struct MainListView_Previews: PreviewProvider {
  static var previews: some View {
    MainListView()
  }
}
