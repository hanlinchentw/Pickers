//
//  MainPageHeader.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/6.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol MainPageHeaderDelegate : AnyObject {
  func handleHeaderGotTapped()
}

class MainPageNavigationBar : UIView {
  //MARK: - Properties
//  var switchMode: Observable<Void>!
//  var mode = PublishSubject<MainPageMode>()

  private var shouldShowMapView = false

  weak var delegate : MainPageHeaderDelegate?

  private lazy var listModeButton : UIButton = createModeButton(withTitle: "List")
  private lazy var mapModeButton : UIButton = createModeButton(withTitle: "Map")

  private let blackDot : UIView = {
    let view = UIView()
    view.backgroundColor = .customblack
    view.heightAnchor.constraint(equalToConstant: 5).isActive = true
    view.widthAnchor.constraint(equalToConstant: 5).isActive = true
    view.layer.cornerRadius = 5 / 2
    return view
  }()

  private let disposeBag = DisposeBag()
  //MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    binding()
    configureUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func binding() {
//    switchMode = Observable.of(listModeButton.rx.tap, mapModeButton.rx.tap).merge()
//
//    self.mode
//      .skip(1)
//      .bind { [weak self] newMode in
//        guard let self = self else { return }
//        let isListMode = newMode == MainPageMode.list
//        self.blackDot.frame.origin.x = isListMode ? self.listModeButton.center.x : self.mapModeButton.center.x
//        self.listModeButton.isUserInteractionEnabled = !isListMode
//        self.mapModeButton.isUserInteractionEnabled = isListMode
//        self.delegate?.handleHeaderGotTapped()
//      }.disposed(by: disposeBag)
  }
}
// MARK: - UI
extension MainPageNavigationBar {
  func configureUI() {
    backgroundColor = .white
    layer.cornerRadius = 36
    layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    layer.masksToBounds = true

    let navItemStack = UIStackView(arrangedSubviews: [listModeButton, mapModeButton])
    navItemStack.axis = .horizontal
    navItemStack.distribution = .fillEqually
    navItemStack.alignment = .bottom

    addSubview(navItemStack)
    navItemStack.anchor(top: topAnchor, left: leftAnchor,
                        right: rightAnchor, bottom: bottomAnchor, paddingBottom: 16)

    addSubview(blackDot)
    blackDot.centerX(inView: listModeButton)
    blackDot.anchor(bottom: bottomAnchor, paddingBottom: 12)

    listModeButton.titleEdgeInsets = UIEdgeInsets(top: listModeButton.frame.height/2, left: 0, bottom: 0, right: 0)
    mapModeButton.titleEdgeInsets = UIEdgeInsets(top: mapModeButton.frame.height/2, left: 0, bottom: 0, right: 0)
  }
}
// MARK: - Helpers
extension MainPageNavigationBar {
  private func createModeButton(withTitle title: String) -> UIButton {
    let button = UIButton(type: .custom)
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = UIFont(name: "Arial-BoldMT", size: 16)
    button.setTitleColor(.black, for: .normal)
    button.backgroundColor = .white
    return button
  }
}
