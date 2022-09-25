//
//  PresentHelper.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/20.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit
import SwiftUI
import Toast_Swift

final class PresentHelper {
  static var topViewController: UIViewController? {
    return UIApplication.shared.keyWindow?.rootViewController
  }

  static func showAlert<Content: View>(model: AlertPresentationModel, content: (() -> Content)? = nil) {
    let alertView = Alert(model: model, content: content)
    let alertVC = UIHostingController(rootView: alertView)
    alertVC.modalPresentationStyle = .overCurrentContext
    alertVC.modalTransitionStyle = .crossDissolve
    alertVC.view.backgroundColor = .clear
    topViewController?.present(alertVC, animated: true)
  }

  static func showTapToast(
		on vc: UIViewController? = topViewController,
    withTitle title: String? = nil,
    withMessage message: String,
    duration: TimeInterval,
    position: ToastPosition,
    style: ToastStyle,
    tap: @escaping (Bool) -> Void
  ) {
    ToastManager.shared.isTapToDismissEnabled = true
		let point = CGPoint(x: UIScreen.screenWidth / 2, y: SafeAreaUtils.top + 32)
		vc?.view?.hideAllToasts()
		vc?.view?.makeToast(message, duration: duration, point: point, title: title, image: nil, style: style, completion: tap)
  }
	
	static func showToast(
		on vc: UIViewController? = topViewController,
		withTitle title: String? = nil,
		withMessage message: String,
		duration: TimeInterval,
		position: ToastPosition,
		style: ToastStyle
	) {
		let point = CGPoint(x: UIScreen.screenWidth / 2, y: SafeAreaUtils.top + 32)
		vc?.view?.hideAllToasts()
		vc?.view?.makeToast(message, duration: duration, point: point, title: title, image: nil, style: style, completion: { _ in })
	}
	
}
