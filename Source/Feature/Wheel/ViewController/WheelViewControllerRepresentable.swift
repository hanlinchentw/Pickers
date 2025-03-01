//
//  WheelViewControllerRepresentable.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/4/2.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import SwiftUI

struct WheelViewControllerRepresentable: UIViewControllerRepresentable {
  typealias UIViewControllerType = WheelViewController

  func makeUIViewController(context: Context) -> WheelViewController {
    let interactor = WheelInteractor()
    let presenter = WheelPresenter()
    let view = WheelViewController(presenter: presenter)
    presenter.view = view
    presenter.interactor = interactor
    return view
  }

  func updateUIViewController(_ uiViewController: WheelViewController, context: Context) {
    uiViewController.refreshView()
  }
}

#Preview {
  WheelViewControllerRepresentable()
}
