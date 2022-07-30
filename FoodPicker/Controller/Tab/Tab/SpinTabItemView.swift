//
//  SpinImageView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/7/30.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SpinTabItemView: UIImageView {
//MARK: - Properties
  var displayNumber = BehaviorRelay(value: 0)

  var increase: () -> Void {
    let newValue = self.displayNumber.value + 1
    return { self.displayNumber.accept(newValue) }
  }

  var decrease: () -> Void {
    let newValue = self.displayNumber.value - 1
    return { self.displayNumber.accept(newValue) }
  }

  private let numOfSelectedLabel : UILabel = {
    let label = UILabel()
    label.font = UIFont.arialBoldMT
    label.textColor = .white
    return label
  }()

  var disposeBag = DisposeBag()
//MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    displayLabelBinding()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
//MARK: - UI
  private func configureUI() {
    backgroundColor = .butterscotch
    image = UIImage(named: "spinActive")
    contentMode = .scaleAspectFit
    setDimension(width: 54, height: 54)
    layer.cornerRadius = 54 / 2

    addSubview(numOfSelectedLabel)
    numOfSelectedLabel.center(inView: self)
  }

  private func displayLabelBinding() {
    displayNumber
      .map { $0.toString }
      .bind(onNext: { [weak self] newNumberStr in
        if newNumberStr.toInt == 0 {
          self?.numOfSelectedLabel.rx.text.onNext(nil)
          self?.image = UIImage(named: "spinActive")
        } else {
          self?.numOfSelectedLabel.rx.text.onNext(newNumberStr)
          self?.numOfSelectedLabel.performBounceAnimataion(scale: 1.5, duration: 0.2)
          self?.image = nil
        }
      })
      .disposed(by: disposeBag)
  }
}

