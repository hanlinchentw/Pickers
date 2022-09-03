//
//  MapView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/30.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: View {
  @StateObject var viewModel = MapViewModel()
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    ZStack(alignment: .top) {
      Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.annotationItems) { item in
        MapAnnotation(coordinate: item.coordinate) {
          Image("btnLocationUnselect")
            .frame(width: 29, height: 39)
        }
    }
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
      ListButton {
        self.presentationMode.wrappedValue.dismiss()
      }
    }
    .navigationBarHidden(true)
    .task {
      MBProgressHUDHelper.showLoadingAnimation()
      await viewModel.fetchRestaurantNearby()
      MBProgressHUDHelper.hideLoadingAnimation()
    }
  }

}

struct MapView_Previews: PreviewProvider {
  static var previews: some View {
    MapView()
  }
}

struct ListButton: View  {
  var dismissMap: () -> Void

  var body: some View {
    HStack {
      Spacer()
      Button {
        dismissMap()
      } label: {
        RoundedRectangle(cornerRadius: 12)
          .fill(Color.white)
          .frame(width: 48, height: 48)
          .overlay {
            Image(systemName: "line.3.horizontal")
              .foregroundColor(.butterScotch)
              .frame(width: 44, height: 44)
          }
      }
      .padding(.top, 32)
      .padding(.trailing, 16)
    }
  }
}
