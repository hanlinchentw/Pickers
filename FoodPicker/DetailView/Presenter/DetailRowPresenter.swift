//
//  DetailRowPresenter.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/20.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

protocol DetailCellDelegate : AnyObject {
  func didTapActionButton(_ config: DetailConfig)
}

enum DetailConfig: Int, CaseIterable {
  case main = 0
  case businessHour
  case address
  case phone
}

protocol DetailRowPresenter {
  var delegate: DetailCellDelegate? { get set }

  var icon: String? { get }
  var iconIsHidden: Bool { get }
  var title: String { get }
  var content: NSAttributedString? { get }
  var rightText: String? { get }
  var actionButtonIsHidden: Bool { get }
  var actionButtonImageName: String? { get }

  func actionButtonTapped()
}

extension DetailRowPresenter {
  func actionButtonTapped() {}
}

final class DetailRowPresenterMapper {
  static func mapPresenterFromDetailConfig(_ config: DetailConfig, detail: Detail, isExpanded: Bool) -> DetailRowPresenter {
    switch config {
    case .main: return FirstRowPressenter(.main, detail: detail)
    case .businessHour: return SecondRowPresenter(.businessHour, detail: detail, isExpanded: isExpanded)
    case .address: return ThirdRowPresenter(.address, detail: detail)
    case .phone: return FourthRowPresenter(.phone, detail: detail)
    }
  }
}
