//
//  MapView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/30.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI
import MapKit

class MapViewModel: ObservableObject {
  //  @Published var region: MKCoordinateRegion
  //
  //  init() {
  //    @Inject var locationService: LocationService
  //
  //    self.region =
  //  }
}

struct MapView: View {
  //  @StateObject var viewModel = MapViewModel()
  @Environment(\.presentationMode) var presentationMode

  @State var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(
      latitude: 24.97524558,
      longitude: 121.53519691
    ),
    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
  )
  var body: some View {
    Map(coordinateRegion: $region)
      .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
      .overlay {
        HStack {
          VStack {
            Button {
              self.presentationMode.wrappedValue.dismiss()
            } label: {
              RoundedRectangle(cornerRadius: 22)
                .fill(Color.white)
                .frame(width: 44, height: 44)
                .overlay {
                  Image("icnBack")
                }
            }
            .padding(.top, 32)
            .padding(.leading, 16)
            Spacer()
          }
          Spacer()
        }
      }
      .navigationBarHidden(true)
  }
}

struct MapView_Previews: PreviewProvider {
  static var previews: some View {
    MapView()
  }
}
