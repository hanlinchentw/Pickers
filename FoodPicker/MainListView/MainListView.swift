//
//  MainListView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/12.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct MainListView: View {
  @StateObject var locationService = LocationService.shared

  @State private var inputText: String = ""

  var body: some View {
    ZStack {
      Color.listViewBackground.ignoresSafeArea()
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 24) {
          SearchFieldContainer(inputText: inputText)
          HorizontalSectionContainer().environmentObject(locationService)
          VerticalListContainer()
        }
      }
    }
    .navigationBarHidden(true)
  }
}

struct MainListView_Previews: PreviewProvider {
  static var previews: some View {
    MainListView()
  }
}
