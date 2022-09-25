//
//  ActionController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import CoreData
import Combine
import SwiftUI

class SpinViewController: UIViewController {
	static let wheelWidth: CGFloat = 330
	static let wheelHeight: CGFloat = 330
	//MARK: - Properties
	let presenter = SpinWheelPresenter()
	
	private lazy var startButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(named: "btnSpin")?.withRenderingMode(.alwaysOriginal), for: .normal)
		button.imageView?.contentMode = .scaleAspectFit
		button.addTarget(self, action: #selector(handleStartButtonTapped), for: .touchUpInside)
		button.isUserInteractionEnabled = false
		return button
	}()
	
	private lazy var listButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(named: "btnNote")?.withRenderingMode(.alwaysOriginal), for: .normal)
		button.addTarget(self, action: #selector(handleListButtonTapped), for: .touchUpInside)
		return button
	}()
	
	private lazy var cleanButton: UIButton = {
		let button = UIButton()
		button.layer.cornerRadius = 12
		button.backgroundColor = .white
		button.setImage(UIImage(systemName: "minus.circle"), for: .normal)
		button.tintColor = .butterscotch
		button.addTarget(self, action: #selector(handleCleanButtonTapped), for: .touchUpInside)
		return button
	}()
	
	private var resultView = SpinResultView()
	
	private var spinWheel = SpinWheel(frame: CGRect(x: 0, y: 0, width: wheelWidth, height: wheelHeight))
	
	private let bottomSheetVC = BottomSheetViewController()
	private var set = Set<AnyCancellable>()
	//MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		configureWheel()
		configureListButton()
		configureCleanButton()
		configureResultView()
		presenter.refresh()
		bindRefresh()
		bindResult()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		configureBottomSheetView()
		presenter.refresh()
		view.backgroundColor = .backgroundColor
		navigationController?.navigationBar.isHidden = true
		navigationController?.navigationBar.barStyle = .default
		navigationController?.navigationBar.isTranslucent = true
		tabBarController?.tabBar.isHidden = false
		tabBarController?.tabBar.isTranslucent = true
	}
	
	func bindRefresh() {
		presenter.$isRefresh
			.sink { _ in
				self.spinWheel.reloadData()
				self.startButton.isUserInteractionEnabled = self.presenter.isSpinButtonEnabled
			}
			.store(in: &set)
	}
	//MARK: - Selectors
	@objc func handleStartButtonTapped() {
		self.resultView.restaurant = nil
		self.startButton.changeImageButtonWithBounceAnimation(changeTo: "btnSpin")
		let resultNumber = Int.random(in: 1...presenter.restaurants.count)
		wheelSpin(targetIndex: resultNumber)
		bottomSheetVC.animateIn(.bottom)
	}
	
	func wheelSpin(targetIndex: Int) {
		self.spinWheel.setTarget(section: targetIndex)
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
			self.spinWheel.manualRotation(aCircleTime: 0.15)
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
				self.spinWheel.stop()
			}
		}
	}
	
	@objc func handleListButtonTapped() {
		guard let nav = self.navigationController else {
			return
		}
		let coordinator = SavedListCoordinator(navigationController: nav)
		coordinator.pushToSavedListView { list in
			self.presenter.applyList(list)
			self.bottomSheetVC.applyList(list)
		}
	}
	
	@objc func handleCleanButtonTapped() {
		PresentHelper.showAlert(model:
				.init(
					rightButtonText: "OK",
					leftButtonText: "Cancel",
					rightButtonOnPress: {
						self.presenter.reset()
						self.bottomSheetVC.reset()
						self.resultView.restaurant = nil
					}
				)
		) {
			Text("Reset Picker")
				.en18Bold()
				.foregroundColor(.butterScotch)
				.padding(.top, 16)
		}
	}
}
//MARK: - LuckyWheelDelegate, LuckyWheelDataSource
extension SpinViewController: SpinWheelDelegate, SpinWheelDataSource {
	func wheelDidChangeValue(_ newValue: Int) {
		presenter.resultDidChanged(newValue)
	}
	
	func numberOfSections() -> Int {
		return presenter.numOfSection
	}
	func itemsForSections() -> [WheelItem] {
		return presenter.itemForSection
	}
}
//MARK: -  BottomSheetDelegate
extension SpinViewController: BottomSheetViewControllerDelegate{
	func shouldHideResultView(shouldHide: Bool) {
		if shouldHide {
			UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
				self.resultView.alpha = 0
			}
		}else {
			UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
				self.resultView.alpha = 1
			}
		}
	}
}
//MARK: - Auto layout
extension SpinViewController {
	func configureWheel(){
		spinWheel.delegate = self
		spinWheel.dataSource = self
		spinWheel.isUserInteractionEnabled = false
		spinWheel.animateLanding = true
		
		let wheelContainerView = UIView()
		view.addSubview(wheelContainerView)
		wheelContainerView.centerX(inView: self.view)
		wheelContainerView.anchor(top: self.view.topAnchor, paddingTop: 60)
		wheelContainerView.setDimension(width: Self.wheelWidth, height: Self.wheelHeight)
		
		wheelContainerView.addSubview(spinWheel)
		spinWheel.fit(inView: wheelContainerView)
		
		wheelContainerView.addSubview(startButton)
		startButton.center(inView: wheelContainerView)
		startButton.setDimension(width: 85, height: 85)
		startButton.layer.cornerRadius = 40 / 2
	}
	
	func configureListButton(){
		view.addSubview(listButton)
		listButton.anchor(top: view.topAnchor, right: view.rightAnchor,
											paddingTop: 52, paddingRight: 20,
											width: 40, height: 40)
		
	}
	
	func configureCleanButton() {
		view.addSubview(cleanButton)
		cleanButton.anchor(top: view.topAnchor, left: view.leftAnchor,
											 paddingTop: 52, paddingLeft: 20,
											 width: 40, height: 40)
	}
	
	func configureBottomSheetView(){
		self.addChild(bottomSheetVC)
		bottomSheetVC.delegate = self
		self.view.addSubview(bottomSheetVC.view)
		let height = view.frame.height
		let width  = view.frame.width
		let offset = 72 * view.widthMultiplier + Self.wheelHeight + 24
		
		bottomSheetVC.view.frame = CGRect(x: 0, y: offset, width: width, height: height)
	}
	
	func configureResultView() {
		view.addSubview(resultView)
		resultView.centerX(inView: self.view)
		resultView.anchor(top: self.spinWheel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
		resultView.setDimension(height: 280)
	}
	
	func bindResult(){
		self.presenter.$result
			.compactMap { $0 }
			.receive(on: RunLoop.main)
			.sink { self.resultView.restaurant = $0 }
			.store(in: &set)
	}
}
