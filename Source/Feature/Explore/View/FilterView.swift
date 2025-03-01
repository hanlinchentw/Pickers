//
//  FilterView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/3/17.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import SwiftUI

struct FilterView: View {
  var title: String
  var description: String

  @Binding var value: Double
  let set: StrideArray<Double>

  var body: some View {
    VStack {
      Text(title).bold(size: 17)
      Divider()
      HStack {
        Text(description).medium(size: 15)
          .padding()
        Spacer()
      }
      if let min = set.minValue, let max = set.maxValue {
        Slider(
          value: $value,
          in: min...max,
          step: set.stepSize
        )
        .tint(.butterScotch)
        .padding(.horizontal)
      }

      Group {
        Button {
        } label: {
          Text("Apply")
            .medium(size: 17)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
          RoundedRectangle(cornerRadius: 12)
            .fill(Color.butterScotch)
        )
        .padding(.horizontal)
        .tint(.white)
        .padding(.top, 32)

        Button {
        } label: {
          Text("Reset")
            .medium(size: 17)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .tint(.black)
      }
    }
  }
}

#Preview {
  FilterView(
    title: "Rating",
    description: "Over \(1)",
    value: .constant(3.5),
    set: .init(elements: [3, 3.5, 4, 4.5, 5])
  )
}
