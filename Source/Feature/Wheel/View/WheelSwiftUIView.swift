//
//  WheelSwiftUIView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/10/6.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import SwiftUI

struct WheelSwiftUIView: View {
  @State var isSheetPresented = false

  var onExploring: () -> Void

  var body: some View {
    VStack {
      HStack {
        imageBtn(name: "gearshape.fill", size: 28)
        Spacer()
        currentListView
        Spacer()
        imageBtn(name: "note.text.badge.plus", size: 28)
      }
      .padding(.horizontal)
      WheelViewControllerRepresentable()
      editListBtn
    }
    .sheet(isPresented: $isSheetPresented) {
      VStack {
        RoundedRectangle(cornerRadius: 2)
          .frame(width: 80, height: 4)
          .foregroundStyle(Color.gray4)
        SwitchPocketView(lists: [
          .init(id: "1", name: "Pocket Name A"),
          .init(id: "2", name: "Pocket Name B")
        ], onExplore: {
          isSheetPresented = false
          onExploring()
        })
      }
      .safeAreaPadding(.top, 16)
    }
  }
}

// MARK: - Sub views
private extension WheelSwiftUIView {
  var dummyView: some View {
    Image(systemName: "chevron.down").opacity(0)
  }

  var currentListView: some View {
    HStack(spacing: 20) {
      dummyView
      Text("First list").en16Bold()
      Image(systemName: "chevron.down")
        .resizable()
        .scaledToFit()
        .frame(width: 14)
    }
    .foregroundStyle(Color.primary)
    .frame(width: UIScreen.screenWidth / 2, height: 48)
    .overlay {
      RoundedCorner(radius: 24)
        .stroke(.black)
    }
    .onTapGesture {
      isSheetPresented = true
    }
  }

  var editListBtn: some View {
    HStack {
      Spacer()
      imageBtn(name: "pencil", size: 24)
        .padding()
        .overlay {
          Circle().stroke(Color.primary)
        }
    }
    .padding()
  }
}

private extension WheelSwiftUIView {
  @ViewBuilder
  func imageBtn(name: String, size: CGFloat) -> some View {
    Button {
      onExploring()
    } label: {
      Image(systemName: name)
        .resizable()
        .scaledToFit()
        .frame(height: size)
        .foregroundStyle(Color.primary)
    }
  }
}

#Preview {
  WheelSwiftUIView {
  }
}
