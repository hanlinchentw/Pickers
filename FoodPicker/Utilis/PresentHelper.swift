//
//  PresentHelper.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/20.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit
import SwiftUI

final class PresentHelper {
  static var topViewController: UIViewController? {
    return UIApplication.shared.keyWindow?.rootViewController
  }

  static func showAlert(model: AlertPresentationModel) {
    let alertView = Alert(model: model)
    let alertVC = UIHostingController(rootView: alertView)
    alertVC.modalPresentationStyle = .overCurrentContext
    alertVC.modalTransitionStyle = .crossDissolve
    alertVC.view.backgroundColor = .clear
    topViewController?.present(alertVC, animated: true)
  }
}
