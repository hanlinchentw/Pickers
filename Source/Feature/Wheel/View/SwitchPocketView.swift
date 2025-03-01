//
//  SwitchPocketView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/10/6.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import SwiftUI

struct SwitchPocketView: View {
  @State var lists = [ListShortcutViewModel]()
  var onExplore: () -> Void

  var body: some View {
    VStack(alignment: .center) {
      List {
        Section {
          ForEach(lists) { list in
            HStack {
              PizzaView()
                .frame(width: 48, height: 48)
                .padding(.horizontal)
              Text(list.name).en18Medium()
              Spacer()
            }
            .padding()
            .overlay {
              RoundedCorner(radius: 16)
                .stroke(Color.gray8)
            }
            .swipeActions {
              Button {
              } label: {
                Image(systemName: "pencil.circle")
              }
              .tint(Color.freshGreen)

              Button {
              } label: {
                Image(systemName: "trash")
              }
              .tint(Color.red)
            }
          }
          .listRowSeparator(.hidden)
        }

        Section {
          Button {
            onExplore()
          } label: {
            HStack {
              Image(systemName: "plus")
              Text("Create New Pocket List")
            }
          }
          .foregroundStyle(Color.accentColor)
          .padding()
        }
        .listSectionSeparator(.hidden)
      }
      .listStyle(.plain)
    }
  }
}

#Preview {
  SwitchPocketView(lists: [
    .init(id: "1", name: "Pocket Name A"),
    .init(id: "2", name: "Pocket Name B")
  ], onExplore: {})
}

struct PizzaView: View {
  let colors: [Color] = [.red, .green, .blue, .yellow] // Array of colors for the sections

  var body: some View {
    ZStack {
      // Divide the circle into four sections
      ForEach(0..<4) { index in
        // Create each section using a Path
        PizzaSlice(
          startAngle: Angle(degrees: Double(index) * 90),
          endAngle: Angle(degrees: Double(index + 1) * 90)
        )
        .fill(colors[index]) // Fill each slice with a different color
      }
    }
  }
}

struct PizzaSlice: Shape {
  var startAngle: Angle
  var endAngle: Angle

  // Create the path for each slice of the pizza
  func path(in rect: CGRect) -> Path {
    var path = Path()
    let center = CGPoint(x: rect.midX, y: rect.midY)
    let radius = min(rect.width, rect.height) / 2

    // Move to the center of the circle
    path.move(to: center)

    // Add an arc to form a quarter circle
    path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)

    // Close the path back to the center to form the slice
    path.closeSubpath()

    return path
  }
}
