//
//  RootView.swift
//  Picker
//
//  Created by 陳翰霖 on 2023/6/28.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Combine
import CoreLocation
import SwiftData
import SwiftUI

struct RootView: View {
  @State private var selectStore = PlacesSelectionStore()
  @State private var locationManager = LocationManager()
  @State private var exploreModel = ExploreModel()
  @State private var navigator = RootNavigator()
  @Query private var userAddresses: [SDUserAddress]

  @State private var isExploringMode = false

  @Environment(\.modelContext) var context

  init(exploreModel: ExploreModel = ExploreModel()) {
    self.exploreModel = exploreModel
  }

  var body: some View {
    NavigationStack(path: $navigator.path) {
      WheelSwiftUIView {
        withAnimation(.easeInOut(duration: 0.5)) {
          isExploringMode = true
        }
      }
      .fullScreenCover(isPresented: $isExploringMode, content: {
        ExploreView(
          userAddress: UserAddress(sdAddress: userAddresses[safe: 0]),
          exploreModel: exploreModel
        )
        .modelContainer(context.container)
        .if(!selectStore.selectedPlaces.isEmpty) {
          $0
            .overlay {
              VStack {
                Spacer()
                ZStack {
                  Color.white
                  Text("Hello")
                }
                .frame(height: 72)
              }
              .ignoresSafeArea()
            }
        }
      })
    }
    .environment(selectStore)
    .environment(locationManager)
    .navigationBarHidden(true)
    .onAppear {
      locationManager.updateStatus()
      exploreModel.setupRepos(
        placeRepositories: [ApplePlaceRepository(locationManager: locationManager)],
        selectStore: selectStore
      )
    }
  }
}

#Preview {
  RootView(
    exploreModel: .init()
  )
  .modelContainer(
    DependencyContainer.shared.getPreviewPlaceModelContainer().modelContainer
  )
}
