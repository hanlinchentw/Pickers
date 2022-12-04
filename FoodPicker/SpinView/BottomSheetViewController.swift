//
//  BottomSheetViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/8/7.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import Combine
import CoreData
import SwiftUI

private let selectedIdentifier = "RestaurantListCell"

class BottomSheetViewController : UIViewController {
	//MARK: - Properties
	private let viewModel = BottomSheetViewModel()
	private let notchView = NotchView()
	private let titleLabel = UILabel("My selected list", font: .arial16BoldMT, color: .black)
	private let saveButton = ListSaveButton()
	private let updateButton = ListUpdateButton()
	private let collectionView = RestaurantsList()
	private var set = Set<AnyCancellable>()
	//MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		configurePanGesture()
		configureUI()
		configureTableView()
		configureButton()
		
		bindRefresh()
		bindListState()
		bindErrorState()
		viewModel.observeContextObjectsChange()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		viewModel.refresh()
		animateIn(.middle)
	}
	// MARK: - Binding
	private func bindRefresh() {
		viewModel.$isRefresh
			.sink { _ in
				self.collectionView.restaurants = self.viewModel.restaurants
			}
			.store(in: &set)
	}
	//MARK: - Selectors
	@objc func handleSaveButtonTapped() {
		if viewModel.hasNoRestaurantSelected {
			viewModel.error = .saveEmptyList
			return
		}
		
		let alertVC = UIAlertController(title: "Save list", message: nil, preferredStyle: .alert)
		alertVC.addTextField { (tf) in
			tf.placeholder = "Enter list name"
			tf.keyboardType = .asciiCapable
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
			guard let name = alertVC.textFields?[0].text, !name.isEmpty else {
				self.viewModel.error = .listHaveNoName
				return
			}
			self.viewModel.createList(name: name)
		}
		alertVC.addAction(cancelAction)
		alertVC.addAction(saveAction)
		present(alertVC, animated: true, completion: nil)
	}
	
	@objc func handleUpdateButtonTapped() {
		if viewModel.hasNoRestaurantSelected {
			viewModel.error = .updateEmptyList(delete: {
				self.viewModel.deleteList()
			})
		} else {
			self.viewModel.updateList()
		}
	}
	
	func reset() {
		viewModel.reset()
	}
	
	func applyList(_ list: List) {
		viewModel.applyList(list)
	}
}
//MARK: -  List State change animation
extension BottomSheetViewController{
	func bindListState() {
		viewModel.$listState
			.sink { state in
				OperationQueue.main.addOperation {
					UIView.animate(withDuration: 0.15, animations: {
						self.titleLabel.text = self.viewModel.listName
						self.saveButton.setTitle(self.viewModel.saveButtonText, for: .normal)
						self.saveButton.isHidden = self.viewModel.saveButtonHidden
						self.updateButton.isHidden = self.viewModel.updateButtonHidden
					})
					self.view.layoutIfNeeded()
				}
			}
			.store(in: &set)
	}
	
	func bindErrorState() {
		viewModel.$error
			.compactMap { $0 }
			.sink { error in
			PresentHelper.showAlert(model: error.alertModel)
		}
		.store(in: &set)
	}
}
//MARK: - RestaurantsListDelegate
extension BottomSheetViewController: RestaurantsListDelegate {
	func didTapActionButton(_ restaurant: RestaurantViewObject, indexPath: IndexPath) {
		OperationQueue.main.addOperation {
			self.viewModel.didTapSelectButton(restaurant, at: indexPath)
		}
	}
	
	func didTapAddButton() {
		let alertVC = UIAlertController(title: "Custom Option", message: nil, preferredStyle: .alert)
		alertVC.addTextField { (tf) in
			tf.placeholder = "Enter the name"
			tf.keyboardType = .asciiCapable
			tf.autocapitalizationType = .none
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		let saveAction = UIAlertAction(title: "Add", style: .default) { (action) in
			guard let name = alertVC.textFields?[0].text, !name.isEmpty else {
				return
			}
			self.viewModel.addCustomOption(name: name)
		}
		alertVC.addAction(cancelAction)
		alertVC.addAction(saveAction)
		present(alertVC, animated: true, completion: nil)
	}
}
//MARK: - UIGestureRecognizerDelegate
extension BottomSheetViewController: UIGestureRecognizerDelegate {
	@objc func panGesture(recognizer: UIPanGestureRecognizer) {
		let translation = recognizer.translation(in: self.view)
		let oldYPosition = self.view.frame.minY
		let newYPosition = oldYPosition + translation.y
		switch recognizer.state {
		case .changed:
			if newYPosition <= 0 { return }
			self.view.frame = CGRect(x: 0, y: newYPosition, width: view.frame.width, height: view.frame.height)
			recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
		case .ended:
			if newYPosition < UIScreen.main.bounds.height / 1.5, newYPosition > UIScreen.main.bounds.height / 3 {
				self.animateIn(.middle)
			} else if newYPosition > UIScreen.main.bounds.height / 1.5 {
				self.animateIn(.bottom)
			} else {
				self.animateIn(.top)
			}
		default: break
		}
	}

	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		let y = view.frame.minY
		if y < 200{
			collectionView.isScrollEnabled = true
		} else {
			collectionView.isScrollEnabled = false
		}
		return false
	}
}
//MARK: - Auto layout and view set up method
extension BottomSheetViewController {
	func configurePanGesture(){
		let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(recognizer:)))
		gesture.delegate = self
		view.addGestureRecognizer(gesture)
	}
	
	func configureUI(){
		view.layer.cornerRadius = 24
		view.backgroundColor = .white
		view.addSubview(notchView)
		notchView.setDimension(width: 60, height: 4)
		notchView.anchor(top: view.topAnchor, paddingTop: 8)
		notchView.centerX(inView: view)
		
		view.addSubview(titleLabel)
		titleLabel.anchor(top: notchView.bottomAnchor, left: view.leftAnchor, paddingTop: 24, paddingLeft: 16)
	}
	
	func configureTableView() {
		view.addSubview(collectionView)
		collectionView.anchor(top: titleLabel.bottomAnchor, left:view.leftAnchor,
										 right: view.rightAnchor,bottom: view.bottomAnchor,
										 paddingTop: 16, paddingBottom: 200)
		collectionView.listDelegate = self
	}
	
	func configureButton() {
		view.addSubview(saveButton)
		saveButton.anchor(top: titleLabel.topAnchor, right: view.rightAnchor, paddingRight: 16)
		saveButton.setDimension(width: 104, height: 32)
		saveButton.addTarget(self, action: #selector(handleSaveButtonTapped), for: .touchUpInside)
		
		view.addSubview(updateButton)
		updateButton.anchor(top: titleLabel.topAnchor, right: saveButton.leftAnchor, paddingRight: 16)
		updateButton.setDimension(width: 81, height: 32)
		updateButton.addTarget(self, action: #selector(handleUpdateButtonTapped), for: .touchUpInside)
	}
}
// MARK: - Position
extension BottomSheetViewController {
	enum Position {
		case top
		case middle
		case bottom
		
		var yPosition: CGFloat {
			switch self {
			case .top: return 100
			case .middle: return 100 + 330
			case .bottom: return UIScreen.screenHeight - 116
			}
		}
	}
	
	func animateIn(_ position: BottomSheetViewController.Position){
		UIView.animate(withDuration: 0.3) {
			self.view.frame = CGRect(x: 0, y: position.yPosition,
															 width: self.view.frame.width, height: self.view.frame.height)
			self.saveButton.alpha = position == .bottom ? 0 : 1
			self.updateButton.alpha = position == .bottom ? 0 : 1
		}
	}
}

