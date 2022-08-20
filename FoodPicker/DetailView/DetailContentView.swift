//
//  DetailContentView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/19.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import SwiftUI

struct DetailContentView: UIViewControllerRepresentable {
  typealias UIViewControllerType = DetailController
  var id: String
  @State fileprivate var shouldDismiss = false

  func makeUIViewController(context: Context) -> DetailController {
    let detailVC = DetailController(id: id)
    detailVC.delegate = context.coordinator
    return detailVC
  }

  func updateUIViewController(_ uiViewController: DetailController, context: Context) {
    guard !shouldDismiss || !context.environment.presentationMode.wrappedValue.isPresented else {
      context.environment.presentationMode.wrappedValue.dismiss()
      return
    }
  }

  func makeCoordinator() -> DetailCoordinator {
    return DetailCoordinator(self)

  }

  class DetailCoordinator: NSObject, DetailControllerDelegate {
    var parent: DetailContentView

    init(_ parent: DetailContentView) {
      self.parent = parent
    }
    func willPopViewController(_ controller: DetailController) {
      parent.shouldDismiss = true
    }
  }
}
