//
//  SearchFieldContainer.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/13.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct SearchFieldContainer: View {
  @State var inputText: String

  var body: some View {
    HStack(alignment: .center) {
      TextField("Search for Restaurants", text: $inputText)
        .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0))
        .height(40)
        .roundedViewWithShadow(cornerRadius: 8,
                               backgroundColor: Color.white,
                               shadowColor: Color.gray.opacity(0.3),
                               shadowRadius: 3)
      Spacer()

      Button {
        presentMapView()
      } label: {
        Image("btnGoogleMaps")
          .roundedViewWithShadow(cornerRadius: 8,
                                 backgroundColor: Color.white,
                                 shadowColor: Color.gray.opacity(0.3),
                                 shadowRadius: 3)

      }

    }
    .padding(.top, 16)
    .padding(.leading, 16)
    .padding(.trailing, 8)
  }

  func presentMapView() {
    let mapView = MapView()
    let mapVC = UIHostingController(rootView: mapView)
    mapVC.modalPresentationStyle = .fullScreen
    mapVC.modalTransitionStyle = .flipHorizontal
    PresentHelper.topViewController?.present(mapVC, animated: true)
  }
}

struct SearchFieldContainer_Previews: PreviewProvider {
  static var previews: some View {
    SearchFieldContainer(inputText: "1")
  }
}
