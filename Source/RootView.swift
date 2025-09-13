//
//  RootView.swift
//  Picker
//
//  Created by 陳翰霖 on 2023/6/28.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Combine
import CoreLocation
import SwiftUI

struct RootView: View {
	@State private var locationManager = LocationManager()

	var body: some View {
		MainTabContainerView()
			.environment(locationManager)
	}
}

#Preview {
  RootView()
  .modelContainer(
    DependencyContainer.shared.getPreviewPlaceModelContainer().modelContainer
  )
}
