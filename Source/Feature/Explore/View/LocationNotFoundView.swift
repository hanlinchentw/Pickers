//
//  LocationNotFoundView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/1/12.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import SwiftUI

struct LocationNotFoundView: View {
  var body: some View {
		needTurnOnLocationServiceView
  }

  var needTurnOnLocationServiceView: some View {
    VStack {
      Image("illustrationLocation")
      Link(
        destination: URL(string: UIApplication.openSettingsURLString)!,
        label: {
          Text("Turn on Location service")
            .bold(size: 18)
            .foregroundStyle(Color.butterScotch)
        }
      )
      .buttonStyle(.plain)
    }
  }
}

#Preview {
  LocationNotFoundView()
}
