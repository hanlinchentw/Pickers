//
//  KeyboardHelper.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/17.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Combine
import Foundation
import UIKit

class KeyboardHelper: ObservableObject {
  @Published var height: CGFloat = 0

  private var set = Set<AnyCancellable>()

  init() {
    observeKeyboardEvent()
  }
}

private extension KeyboardHelper {
  func observeKeyboardEvent() {
    NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification).sink { notification in
      guard let userInfo = notification.userInfo,
            let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
      self.height = keyboardRect.height
    }
    .store(in: &set)

    NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification).sink { notification in
      guard let userInfo = notification.userInfo,
            let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
      self.height = 0
    }
    .store(in: &set)
  }
}
