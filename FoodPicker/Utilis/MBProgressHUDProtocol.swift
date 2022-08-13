//
//  MBProgressHUDProtocol.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/11.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit
import MBProgressHUD

final class MBProgressHUDHelper {
  static func showLoadingAnimation() {
      DispatchQueue.main.async {
          guard let window = UIApplication.shared.windows.first else { return }
          let animation = MBProgressHUD.showAdded(to: window, animated: true)
          animation.animationType = .fade
          animation.bezelView.blurEffectStyle = .dark
          animation.contentColor = .white
          animation.label.text = "Loading"
      }
  }

  static func hideLoadingAnimation(){
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
          guard let window = UIApplication.shared.windows.first else { return }
          MBProgressHUD.hide(for: window, animated: true)
      })
  }
}
