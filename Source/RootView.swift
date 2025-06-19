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
	@State private var isExploringMode = false

	@State private var currentPocket: Pocket?

	@State private var animated3d = false
	@State private var scale = 1.0
	@State private var rotation = 0.0
	@State private var offset = CGSize.zero

  @Environment(\.modelContext) var context

  init(exploreModel: ExploreModel = ExploreModel()) {
    self.exploreModel = exploreModel
  }

  var body: some View {
    ZStack {
			if isExploringMode {
				ExploreView(exploreModel: exploreModel) { place in
				}
				.rotation3DEffect(
					.degrees(180),
					axis: (x: 0, y: 1, z: 0)
				)
				.modelContainer(context.container)
				.environment(locationManager)
			} else {
				PocketWheelContainerView(currentPocket: $currentPocket) {
					flipCard()
				}
				.modelContainer(context.container)
			}
    }
		.rotation3DEffect(
			.degrees(animated3d ? 180 : 0),
			axis: (x: 0, y: 1, z: 0)
		)
		.rotationEffect(.degrees(rotation))
		.scaleEffect(scale)
		.animation(.spring(), value: animated3d)
    .environment(selectStore)
    .environment(locationManager)
    .navigationBarHidden(true)
  }

	private func flipCard() {
		let flipped = isExploringMode
		withAnimation(.easeInOut(duration: 2)) {
			scale = 0.9
			rotation = flipped ? -15 : 15
			Task {
				try? await Task.sleep(for: .seconds(0.1))
				animated3d.toggle()
				isExploringMode.toggle()
				try? await Task.sleep(for: .seconds(0.3))
				withAnimation(.spring(duration: 1)) {
					scale = 1
					rotation = 0
				}
			}
		}
	}
}

#Preview {
  RootView(exploreModel: .init())
  .modelContainer(
    DependencyContainer.shared.getPreviewPlaceModelContainer().modelContainer
  )
}
